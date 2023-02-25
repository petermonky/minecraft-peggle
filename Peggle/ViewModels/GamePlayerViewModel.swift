//
//  GamePlayerViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation
import Combine

@MainActor class GamePlayerViewModel: ObservableObject {
    @Published var gameEngine: GameEngine
    var anyCancellable: AnyCancellable?

    init(level: Level) {
        self.gameEngine = GameEngine(level: level)
        anyCancellable = gameEngine.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}
