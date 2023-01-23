//
//  PegViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import Foundation
import SwiftUI

extension PegView {
    class ViewModel: ObservableObject, Hashable {
        @Published var peg: Peg
        @Published var dragOffset = CGSizeZero
        
        init(peg: Peg = BluePeg()) {
            self.peg = peg
        }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            lhs.peg == rhs.peg
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(peg)
        }
    }
}
