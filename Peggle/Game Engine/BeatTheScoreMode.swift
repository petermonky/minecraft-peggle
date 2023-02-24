//
//  BeatTheScoreMode.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/24.
//

import Foundation

class BeatTheScoreMode: GameMode {
    weak var gameEngine: GameEngine?
    let presetLives: Int? = nil

    var goalText: String {
        "Reach target score of \(targetScore)!"
    }

    var presetDuration: Double? {
        guard let gameEngine = gameEngine else {
            return 0
        }
        return Double(10 * (gameEngine.level.pegs.count / 5) + 5) // TODO: constants
    }

    private var targetScore: Int {
        guard let gameEngine = gameEngine else {
            return 0
        }
        let pegs = gameEngine.level.pegs
        return 2_000 * (pegs.map { $0.score }.reduce(0, +) * pegs.count / 300) // TODO: fix score logic with orange pegs
    }

    func handleGameOver() {
        guard let gameEngine = gameEngine else {
            return
        }
        if gameEngine.noTime {
            gameEngine.updateGameState(.lose)
        } else if gameEngine.score >= targetScore {
            gameEngine.updateGameState(.win)
        }
    }
}
