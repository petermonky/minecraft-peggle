//  swiftlint:disable:this file_name
//
//  BoardViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation
import SwiftUI

extension BoardView {
    class ViewModel: ObservableObject {
        @Published private var pegs: Set<Peg>
        @Published var boardSize = CGSize.zero

        init(pegs: Set<Peg> = []) {
            self.pegs = pegs
        }

        var pegViewModels: [PegView.ViewModel] {
            Array(pegs).map { PegView.ViewModel(peg: $0) }
        }

        func addPeg(_ peg: Peg) -> Bool {
            guard !hasOverlappingPeg(peg) else {
                return false
            }
            guard isOverflowingPeg(peg) else {
                return false
            }
            return pegs.insert(peg).inserted
        }

        func removePeg(_ peg: Peg) -> Bool {
            pegs.remove(peg) != nil
        }

        func translatePeg(_ peg: Peg, translation: CGSize) -> Bool {
            let newPeg = peg.clone()
            newPeg.translateBy(translation)

            guard removePeg(peg) else {
                return false
            }
            guard addPeg(newPeg) else {
                _ = addPeg(peg)
                return false
            }
            return true
        }

        func hasOverlappingPeg(_ peg: Peg) -> Bool {
            for existingPeg in pegs where existingPeg.overlapsWith(peg: peg) {
                return true
            }
            return false
        }

        func isOverflowingPeg(_ peg: Peg) -> Bool {
            let pegX = peg.position.x
            let pegY = peg.position.y
            let boardWidth = boardSize.width
            let boardHeight = boardSize.height

            let isWithinHorizontally = pegX > Constants.Peg.radius && pegX < boardWidth - Constants.Peg.radius
            let isWithinVertically = pegY > Constants.Peg.radius && pegY < boardHeight - Constants.Peg.radius

            return isWithinHorizontally && isWithinVertically
        }
    }

}
