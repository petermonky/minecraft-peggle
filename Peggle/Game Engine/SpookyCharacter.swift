//
//  SpookyCharacter.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/24.
//

import Foundation

class SpookyCharacter: GameCharacter {
    weak var gameEngine: GameEngine?
    let name: String = "Spooky"
    let description: String = """
    Boring regular ball got you down? Let's \
    add some spooky magic and watch it \
    teleport like it's no big deal.
    """

    func applyPower() {
        guard let gameEngine = gameEngine else {
            return
        }
        let greenPegs = gameEngine.collidingGreenPegs
        let areGreenPegsNew = gameEngine.collidedPegGameObjects.contains(where: { greenPegs.contains($0) })
        guard !greenPegs.isEmpty,
              !areGreenPegsNew else {
            return
        }
        greenPegs.forEach { greenPeg in
            gameEngine.ballGameObjects.forEach { ball in
                if CollisionManager.hasCollisionBetween(greenPeg, and: ball) {
                    ball.setSpooky()
                }
            }
        }
    }
}
