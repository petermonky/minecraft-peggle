//
//  LevelObjectViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

class LevelObjectViewModel: ObservableObject {
    @Published var levelObject: any LevelObject
    @Published var dragOffset: CGSize
    @Published var zIndex: Double = 0

    init(levelObject: any LevelObject, dragOffset: CGSize = CGSize.zero) {
        self.levelObject = levelObject
        self.dragOffset = dragOffset
    }

    func overlapsWith(_ other: LevelObjectViewModel) -> Bool {
        levelObject.overlapsWith(other.levelObject)
    }

    func translateBy(_ value: CGSize) {
        levelObject.translateBy(value)
    }

    func clone() -> LevelObjectViewModel {
        LevelObjectViewModel(levelObject: levelObject.clone())
    }
}

// MARK: Hashable

extension LevelObjectViewModel: Hashable {
    static func == (lhs: LevelObjectViewModel, rhs: LevelObjectViewModel) -> Bool {
        lhs.levelObject.id == rhs.levelObject.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(levelObject)
    }
}
