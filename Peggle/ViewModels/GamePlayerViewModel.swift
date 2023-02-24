//
//  GamePlayerViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation

@MainActor class GamePlayerViewModel: ObservableObject {
    @Published var gameEngine: GameEngine

    init(level: Level) {
        self.gameEngine = GameEngine(level: level)
    }
}
