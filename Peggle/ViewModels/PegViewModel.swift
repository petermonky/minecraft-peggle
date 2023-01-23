//  swiftlint:disable:this file_name
//
//  PegViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import Foundation

extension PegView {
    class ViewModel: ObservableObject {
        @Published var peg: Peg
        @Published var dragOffset: CGSize

        init(peg: Peg = BluePeg(), dragOffset: CGSize = CGSize.zero) {
            self.peg = peg
            self.dragOffset = dragOffset
        }
    }
}

// MARK: Hashable

extension PegView.ViewModel: Hashable {
    static func == (lhs: PegView.ViewModel, rhs: PegView.ViewModel) -> Bool {
        lhs.peg == rhs.peg
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(peg)
    }
}
