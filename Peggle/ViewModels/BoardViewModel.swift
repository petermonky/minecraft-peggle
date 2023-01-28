//  BoardViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation

typealias BoardViewModel = BoardView.ViewModel

extension BoardView {
    class ViewModel: ObservableObject {
        @Published var pegViewModels: Set<PegViewModel>
        @Published var initialBoardSize: CGSize?
        @Published var currentBoardSize: CGSize?

        init(pegViewModels: Set<PegViewModel> = []) {
            self.pegViewModels = pegViewModels
        }

        var pegArray: [Peg] {
            Array(pegViewModels).map { $0.peg }
        }

        var sizeScale: Double {
            guard let currentBoardSize = currentBoardSize, let initialBoardSize = initialBoardSize else {
                return 1
            }
            return currentBoardSize.height / initialBoardSize.height
        }

        func initialiseBoardSize(boardSize: CGSize) {
            self.initialBoardSize = boardSize
            self.currentBoardSize = boardSize
        }

        func updateBoardSize(boardSize: CGSize) {
            self.currentBoardSize = boardSize
        }

        func loadPegs(_ pegViewModels: [PegViewModel]) {
            self.pegViewModels = Set(pegViewModels)
        }

        func addPeg(_ pegViewModel: PegViewModel) -> Bool {
            guard !hasOverlappingPeg(pegViewModel) else {
                return false
            }
            guard !isOverflowingPeg(pegViewModel) else {
                return false
            }
            return pegViewModels.insert(pegViewModel).inserted
        }

        func removePeg(_ pegViewModel: PegViewModel) -> Bool {
            pegViewModels.remove(pegViewModel) != nil
        }

        func translatePeg(_ pegViewModel: PegViewModel, translation: CGSize) -> Bool {
            let newPegViewModel = pegViewModel.clone()
            newPegViewModel.translateBy(translation)

            guard removePeg(pegViewModel) else {
                return false
            }
            guard addPeg(newPegViewModel) else {
                _ = addPeg(pegViewModel)
                return false
            }
            return true
        }

        func resetPegs() {
            pegViewModels = []
        }

        func hasOverlappingPeg(_ pegViewModel: PegViewModel) -> Bool {
            for oldPegViewModel in pegViewModels where oldPegViewModel.overlapsWith(peg: pegViewModel) {
                return true
            }
            return false
        }

        func isOverflowingPeg(_ pegViewModel: PegViewModel) -> Bool {
            guard let boardWidth = currentBoardSize?.width, let boardHeight = currentBoardSize?.height else {
                return false
            }
            let pegX = pegViewModel.peg.position.x
            let pegY = pegViewModel.peg.position.y

            let isWithinHorizontally = pegX > Constants.Peg.radius && pegX < boardWidth - Constants.Peg.radius
            let isWithinVertically = pegY > Constants.Peg.radius && pegY < boardHeight - Constants.Peg.radius

            return !isWithinHorizontally || !isWithinVertically
        }
    }

}
