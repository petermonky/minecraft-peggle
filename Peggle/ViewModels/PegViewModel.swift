//  PegViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import Foundation

typealias PegViewModel = PegView.ViewModel

extension PegView {
    class ViewModel: ObservableObject {
        @Published var peg: Peg
        @Published var dragOffset: CGSize
        @Published var zIndex: Double = 0

        init(peg: Peg = BluePeg(), dragOffset: CGSize = CGSize.zero) {
            self.peg = peg
            self.dragOffset = dragOffset
        }

        func overlapsWith(peg other: PegViewModel) -> Bool {
            self.peg.position.distance(to: other.peg.position) <= 2 * Constants.Peg.radius
        }

        func translateBy(_ value: CGSize) {
            peg.position.x += value.width
            peg.position.y += value.height
        }

        func clone() -> PegViewModel {
            PegViewModel(peg: Peg(type: peg.type, position: peg.position))
        }
    }
}

// MARK: Hashable

extension PegView.ViewModel: Hashable {
    static func == (lhs: PegViewModel, rhs: PegViewModel) -> Bool {
        lhs.peg == rhs.peg
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(peg)
    }
}
