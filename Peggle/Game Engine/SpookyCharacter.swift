//
//  SpookyCharacter.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/24.
//

import Foundation

class SpookyCharacter: GameCharacter {
    weak var gameEngine: GameEngine?
    var name: String = "Spooky"

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
        gameEngine.ballGameObject?.setSpooky()
    }
}
