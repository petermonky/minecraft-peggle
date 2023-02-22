//
//  GamePlayerViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation

class GamePlayerViewModel: ObservableObject {
    @Published var renderer: Renderer

    init(level: Level) {
        let gameEngine = GameEngine(level: Level.mockData)
        self.renderer = Renderer(gameEngine: gameEngine)
    }
}
