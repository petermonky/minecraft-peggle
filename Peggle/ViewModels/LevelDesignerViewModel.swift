//  LevelDesignerViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import Foundation

typealias LevelDesignerViewModel = LevelDesignerView.ViewModel

extension LevelDesignerView {
    class ViewModel: ObservableObject {
        @Published var paletteViewModel: PaletteViewModel
        @Published var boardViewModel: BoardViewModel
        @Published var actionViewModel: ActionViewModel
        @Published var levelListViewModel: LevelListViewModel
        private var currentLevelId = UUID()
        private let dataManager = DataManager.shared

        init(paletteViewModel: PaletteViewModel = .init(),
             boardViewModel: BoardViewModel = .init(),
             actionViewModel: ActionViewModel = .init(),
             levelListViewModel: LevelListViewModel = .init()) {
            self.paletteViewModel = paletteViewModel
            self.boardViewModel = boardViewModel
            self.actionViewModel = actionViewModel
            self.levelListViewModel = levelListViewModel
        }

        func isCurrentLevel(_ level: Level) -> Bool {
            currentLevelId == level.id
        }

        func resetLevel() {
            currentLevelId = UUID()
            actionViewModel.resetTitle()
            boardViewModel.resetLevelObjects()
        }

        func loadLevel(_ level: Level) {
            currentLevelId = level.id
            actionViewModel.loadTitle(level.title)

            let levelObjects = level.pegs.map { LevelObjectViewModel(levelObject: $0) }
                               + level.blocks.map { LevelObjectViewModel(levelObject: $0) }
            boardViewModel.loadLevelObjects(levelObjects)
        }

        func saveLevel() async throws {
            let level = Level(id: currentLevelId,
                              frame: boardViewModel.initialBoardSize,
                              title: actionViewModel.title,
                              updatedAt: Date.now,
                              pegs: Set(boardViewModel.pegObjectsArray),
                              blocks: Set(boardViewModel.blockObjectsArray))
            currentLevelId = level.id
            levelListViewModel.addLevel(level)
            try await saveData()
        }

        func loadData() async throws {
            let levels = try await dataManager.load()
            levelListViewModel.loadLevels(Set(levels))
        }

        func saveData() async throws {
            try await dataManager.save(levels: Array(levelListViewModel.levels))
        }
    }
}
