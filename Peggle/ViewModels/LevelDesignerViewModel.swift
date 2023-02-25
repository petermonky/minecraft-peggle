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
    @Published var resizeValue: Double = 1
    @Published var rotateValue: Double = 0

    // Board
    @Published var level = Level()
    @Published var levelObject: (any LevelObject)?

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
        self.resizeValue = levelObject.sizeScale
        self.rotateValue = levelObject.rotationScale
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

    func refreshLevelObject() -> Bool {
        guard let levelObject = levelObject else {
            return false
        }
        let newLevelObject = levelObject.clone()
        newLevelObject.resize(to: resizeValue)
        newLevelObject.rotate(to: rotateValue)
        guard removeLevelObject(levelObject) else {
            selectLevelObject(levelObject)
            return false
        }
        guard addLevelObject(newLevelObject) else {
            _ = addLevelObject(levelObject)
            selectLevelObject(levelObject)
            return false
        }
        selectLevelObject(newLevelObject)
        return true
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
        level.scaledToFit(frame: Frame(size: size))
    }

    func createObjectAtPosition(_ location: CGPoint) {
        var levelObject: (any LevelObject)?
        if let pegObject = createPegAtPosition(location) {
            levelObject = pegObject
        } else if let blockObject = createBlockAtPosition(location) {
            levelObject = blockObject
        }
        if let levelObject = levelObject,
           addLevelObject(levelObject) {
            selectLevelObject(levelObject)
        }
    }

    private func addLevelObject(_ levelObject: any LevelObject) -> Bool {
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
        if isSelectedLevelObject(levelObject) {
            self.levelObject = nil
        }
        return false
    }

    func translateLevelObject(_ levelObject: any LevelObject, translation: CGSize) -> Bool {
        let newLevelObject = levelObject.clone()
        newLevelObject.translateBy(translation)
        guard removeLevelObject(levelObject) else {
            selectLevelObject(levelObject)
            return false
        }
        guard addLevelObject(newLevelObject) else {
            selectLevelObject(levelObject)
            _ = addLevelObject(levelObject)
            return false
        }
        selectLevelObject(newLevelObject)
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
        return levelObject.overlapsWith(level.frame)
    }
}
