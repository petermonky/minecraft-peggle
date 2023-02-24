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
    let goalText: String = "Clear all orange pegs!"

    func handleGameOver() {
        guard let gameEngine = gameEngine else {
            return
        }
        if gameEngine.noTime {
            gameEngine.updateGameState(.lose)
        } else if !gameEngine.visiblePegs.contains(where: { $0.peg.type == .orange }) {
            gameEngine.updateGameState(.win)
        } else if gameEngine.noLives && gameEngine.isInState(.idle) {
            gameEngine.updateGameState(.lose)
        }
    }
}
