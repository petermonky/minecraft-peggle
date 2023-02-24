//
//  SiamLeftSiamRightMode.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/24.
//

import Foundation

class SiamLeftSiamRightMode: GameMode {
    weak var gameEngine: GameEngine?
    let presetDuration: Double? = nil
    let presetLives: Int? = nil

    var goalText: String {
        "Clear 3 ball shoots without hitting any pegs!" // TODO: constants
    }

    func handleGameOver() {
        guard let gameEngine = gameEngine else {
            return
        }
        print(gameEngine.hasBallBucketCollision)
        if gameEngine.noLives && gameEngine.isInState(.idle) {
            gameEngine.updateGameState(.win)
        } else if !gameEngine.collidingPegs.isEmpty {
            gameEngine.updateGameState(.lose)
        }
    }
}
