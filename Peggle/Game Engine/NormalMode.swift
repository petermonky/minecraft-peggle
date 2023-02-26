//
//  NormalMode.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/24.
//

import Foundation

class NormalMode: GameMode {
    weak var gameEngine: GameEngine?
    let presetLives: Int? = 10
    let presetDuration: Double? = nil
    var presetBucketShotCount: Int?
    let name: String = "Normal"
    let description: String = "Got balls? Use them wisely to clear all red pegs before you run out!"
    let goalText: String = "Clear all red pegs!"

    func handleGameOver() {
        guard let gameEngine = gameEngine else {
            return
        }
        if gameEngine.noTime {
            gameEngine.updateGameState(.lose)
        } else if !gameEngine.visiblePegs.contains(where: { $0.peg.type == .red }) {
            gameEngine.updateGameState(.win)
        } else if gameEngine.noLives && gameEngine.isInState(.idle) {
            gameEngine.updateGameState(.lose)
        }
    }
}
