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
        @Published var pegs: Set<Peg>
        @Published var boardSize = CGSizeZero
        
        init(pegs: Set<Peg> = []) {
            self.pegs = pegs
        }
        
        var pegViewModels: [PegView.ViewModel] {
            Array(pegs).map{ PegView.ViewModel(peg: $0) }
        }
        
        func addPeg(_ peg: Peg) -> Bool {
            guard !checkOverlap(peg: peg) else {
                return false
            }
            guard checkOverflow(peg: peg) else {
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
        
        func checkOverlap(peg newPeg: Peg) -> Bool { // TODO: rename method to be more clear
            for peg in pegs {
                if newPeg.overlapsWith(peg: peg) {
                    return true
                }
            }
            return false
        }
        
        func checkOverflow(peg: Peg) -> Bool {
            let pegX = peg.position.x
            let pegY = peg.position.y
            let boardWidth = boardSize.width
            let boardHeight = boardSize.height
            
            let isWithinHorizontally = pegX > 40 && pegX < boardWidth - 40
            let isWithinVertically = pegY > 40 && pegY < boardHeight - 40
            
            return isWithinHorizontally && isWithinVertically
        }
    }

}
