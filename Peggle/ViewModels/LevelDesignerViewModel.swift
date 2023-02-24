//
//  LevelDesignerViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import Foundation

@MainActor class LevelDesignerViewModel: ObservableObject {
    // Palette
    @Published private(set) var mode: PaletteButtonType = .bluePeg
    @Published private(set) var pegFactory: PegFactory? = BluePegFactory()
    @Published private(set) var pegPaletteButtons: [PegPaletteButton] = [
        BluePegPaletteButton(),
        OrangePegPaletteButton(),
        GreenPegPaletteButton()
    ]
    @Published private(set) var blockPaletteButton: PaletteButton = BlockPaletteButton()
    @Published private(set) var deletePaletteButton: PaletteButton = DeletePegPaletteButton()

    // Board
    @Published var level = Level()
    @Published private(set) var levelObject: (any LevelObject)?

    // Level list
    @Published private(set) var levels: [Level] = []
    private let dataManager = DataManager()
}

// MARK: - Level
extension LevelDesignerViewModel {
    var pegObjects: [Peg] {
        Array(level.pegs)
    }

    var blockObjects: [Block] {
        Array(level.blocks)
    }

    func isCurrentLevel(_ level: Level) -> Bool {
        self.level == level
    }

    func isSelectedLevelObject(_ levelObject: any LevelObject) -> Bool {
        self.levelObject === levelObject
    }

    func selectLevelObject(_ levelObject: any LevelObject) {
        self.levelObject = levelObject
    }

    func resetLevel() {
        level = Level()
    }

    func deleteLevels(atOffsets indexSet: IndexSet) {
        levels.remove(atOffsets: indexSet)
    }

    func loadLevel(_ level: Level) {
        self.level = level
    }

    func saveLevel() async throws {
        levels = levels.filter { $0 != level }
        levels.append(level)
        try await saveData()
    }

    func loadData() async throws {
        levels = try await dataManager.load()
    }

    func saveData() async throws {
        try await dataManager.save(levels: levels)
    }
}

// MARK: - Palette

extension LevelDesignerViewModel {
    func createBlockAtPosition(_ position: CGPoint) -> Block? {
        guard mode == .block else {
            return nil
        }
        return NormalBlock(position: position)
    }

    func createPegAtPosition(_ position: CGPoint) -> Peg? {
        guard mode != .deletePeg && mode != .block else {
            return nil
        }
        return pegFactory?.createPegAtPosition(position)
    }

    func onPegButtonSelect(pegButton: PegPaletteButton) {
        mode = pegButton.type
        pegFactory = pegButton.factory
    }

    func onBlockButtonSelect() {
        mode = .block
        pegFactory = nil
    }

    func onDeleteButtonSelect() {
        mode = .deletePeg
        pegFactory = nil
    }
}

// MARK: - Board

extension LevelDesignerViewModel {
    var levelObjects: [any LevelObject] {
        pegObjects + blockObjects
    }

    var boardSuccessfullyInitialised: Bool {
        level.frame.width != CGFloat.zero && level.frame.height != CGFloat.zero
    }

    func initialiseFrame(size: CGSize) {
        level.frame = Frame(size: size)
    }

    func createObjectAtPosition(_ location: CGPoint) {
        var levelObject: (any LevelObject)?
        if let pegObject = createPegAtPosition(location) {
            levelObject = pegObject
        } else if let blockObject = createBlockAtPosition(location) {
            levelObject = blockObject
        }
        if let levelObject = levelObject {
            if addLevelObject(levelObject) {
                selectLevelObject(levelObject)
            }
        }
    }

    func addLevelObject(_ levelObject: any LevelObject) -> Bool {
        guard !isOverlapping(levelObject) else {
            return false
        }
        guard !isOverflowing(levelObject) else {
            return false
        }
        if let peg = levelObject as? Peg {
            return level.pegs.insert(peg).inserted
        } else if let block = levelObject as? Block {
            return level.blocks.insert(block).inserted
        }
        return false
    }

    func removeLevelObject(_ levelObject: any LevelObject) -> Bool {
        if let peg = levelObject as? Peg {
            return level.pegs.remove(peg) != nil
        } else if let block = levelObject as? Block {
            return level.blocks.remove(block) != nil
        }
        return false
    }

    func translateLevelObject(_ levelObject: any LevelObject, translation: CGSize) -> Bool {
        let newLevelObject = levelObject.clone()
        newLevelObject.translateBy(translation)
        guard removeLevelObject(levelObject) else {
            return false
        }
        guard addLevelObject(newLevelObject) else {
            _ = addLevelObject(levelObject)
            return false
        }
        return true
    }

    func resetLevelObjects() {
        level.pegs = []
        level.blocks = []
    }

    func isOverlapping(_ levelObject: any LevelObject) -> Bool {
        for other in levelObjects where other.overlapsWith(levelObject) {
            return true
        }
        return false
    }

    func isOverflowing(_ levelObject: any LevelObject) -> Bool {
        guard boardSuccessfullyInitialised else {
            return false
        }
        let boardWidth = level.frame.width
        let boardHeight = level.frame.height
        let objectX = levelObject.position.x
        let objectY = levelObject.position.y

        // TODO: update
        let isWithinHorizontally = objectX > Constants.Peg.radius && objectX < boardWidth - Constants.Peg.radius
        let isWithinVertically = objectY > Constants.Peg.radius && objectY < boardHeight - Constants.Peg.radius

        return !isWithinHorizontally || !isWithinVertically
    }
}
