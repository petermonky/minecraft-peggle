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
    var presetBucketShotCount: Int?
    let name: String = "Beat The Score"
    let description: String = "Tick tock, beat the clock! Score high and fast to win the game."
    private let numberFormatter = NumberFormatter()

    init() {
        numberFormatter.numberStyle = .decimal
    }

    var goalText: String {
        "Reach target score of \(numberFormatter.string(from: NSNumber(value: targetScore)) ?? "-")!"
    }

    var presetDuration: Double? {
        guard let gameEngine = gameEngine else {
            return 0
        }
        return Double(10 * (gameEngine.level.pegs.count / 5) + 10) // TODO: constants
    }

    private var targetScore: Int {
        guard let gameEngine = gameEngine else {
            return 0
        }
        let pegs = gameEngine.level.pegs
        return 75 * (pegs.map { $0.score }.reduce(0, +) * pegs.count)
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
