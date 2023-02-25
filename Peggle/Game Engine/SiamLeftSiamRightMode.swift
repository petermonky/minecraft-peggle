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
    let presetLives: Int? = 3
    var presetBucketShotCount: Int? = 0
    let name: String = "Siam Left, Siam Right"
    let description: String = "Forget luck, aim with precision! Clear all ball shots without hitting any pegs to win."

    var goalText: String {
        "Clear 3 ball shoots without hitting any pegs!" // TODO: constants
    }

    func handleGameOver() {
        guard let gameEngine = gameEngine else {
            return
        }
        if let bucketShotCount = gameEngine.bucketShotCount, bucketShotCount >= 3 {
            gameEngine.updateGameState(.win)
        } else if !gameEngine.collidingPegs.isEmpty {
            gameEngine.updateGameState(.lose)
        } else if gameEngine.noLives && gameEngine.isInState(.idle) {
            gameEngine.updateGameState(.lose)
        }
    }
}
