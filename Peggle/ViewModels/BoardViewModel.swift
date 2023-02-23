//  BoardViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation

typealias BoardViewModel = BoardView.ViewModel

extension BoardView {
    class ViewModel: ObservableObject {
        @Published var levelObjectViewModels: Set<LevelObjectViewModel>
        @Published var initialBoardSize = CGSize.zero
        @Published var currentBoardSize = CGSize.zero

        init(levelObjectViewModels: Set<LevelObjectViewModel> = []) {
            self.levelObjectViewModels = levelObjectViewModels
        }

        var levelObjectsArray: [any LevelObject] {
            Array(levelObjectViewModels).map { $0.levelObject }
        }

        var pegObjectsArray: [Peg] {
            levelObjectsArray.compactMap { $0 as? Peg }
        }

        var blockObjectsArray: [Block] {
            levelObjectsArray.compactMap { $0 as? Block }
        }

        var sizeScale: Double {
            guard boardSuccessfullyInitialised else {
                return 1
            }
            return currentBoardSize.height / initialBoardSize.height
        }

        var boardSuccessfullyInitialised: Bool {
            initialBoardSize != CGSize.zero && currentBoardSize != CGSize.zero
        }

        func initialiseBoardSize(boardSize: CGSize) {
            self.initialBoardSize = boardSize
            self.currentBoardSize = boardSize
        }

        func updateBoardSize(boardSize: CGSize) {
            self.currentBoardSize = boardSize
        }

        func loadLevelObjects(_ levelObjectViewModels: [LevelObjectViewModel]) {
            self.levelObjectViewModels = Set(levelObjectViewModels)
        }

        func addLevelObject(_ levelObjectViewModel: LevelObjectViewModel) -> Bool {
            guard !isOverlapping(levelObjectViewModel) else {
                return false
            }
            guard !isOverflowing(levelObjectViewModel) else {
                return false
            }
            return levelObjectViewModels.insert(levelObjectViewModel).inserted
        }

        func removeLevelObject(_ levelObjectViewModel: LevelObjectViewModel) -> Bool {
            levelObjectViewModels.remove(levelObjectViewModel) != nil
        }

        func translateLevelObject(_ levelObjectViewModel: LevelObjectViewModel, translation: CGSize) -> Bool {
            let newLevelObjectViewModel = levelObjectViewModel.clone()
            newLevelObjectViewModel.translateBy(translation)
            guard removeLevelObject(levelObjectViewModel) else {
                return false
            }
            guard addLevelObject(newLevelObjectViewModel) else {
                _ = addLevelObject(levelObjectViewModel)
                return false
            }
            return true
        }

        func resetLevelObjects() {
            levelObjectViewModels = []
        }

        func isOverlapping(_ levelObjectViewModel: LevelObjectViewModel) -> Bool {
            for oldLevelObjectViewModel in levelObjectViewModels where oldLevelObjectViewModel.overlapsWith(levelObjectViewModel) {
                return true
            }
            return false
        }

        func isOverflowing(_ levelObjectViewModel: LevelObjectViewModel) -> Bool {
            guard boardSuccessfullyInitialised else {
                return false
            }
            let boardWidth = currentBoardSize.width
            let boardHeight = currentBoardSize.height
            let objectX = levelObjectViewModel.levelObject.position.x
            let objectY = levelObjectViewModel.levelObject.position.y

            // TODO: update
            let isWithinHorizontally = objectX > Constants.Peg.radius && objectX < boardWidth - Constants.Peg.radius
            let isWithinVertically = objectY > Constants.Peg.radius && objectY < boardHeight - Constants.Peg.radius

            return !isWithinHorizontally || !isWithinVertically
        }
    }

}
