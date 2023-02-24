//
//  KaboomCharacter.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

class KaboomCharacter: GameCharacter {
    var name: String = "Kaboom"

    func applyPower(gameEngine: GameEngine) {
        gameEngine.explodePegs(gameEngine.collidedGreenPegGameObjects)
    }
}

extension GameEngine {
    fileprivate func explodePegs(_ pegs: [PegGameObject]) {
        guard let ball = ballGameObject else {
            return
        }
        removePegs(pegs)
        for peg in pegs {
            let distance = peg.position.distance(to: ball.position)
            if distance <= 100 { // TODO: move to constants
                var explosionVector = CGVector(from: peg.position, to: ball.position)
                explosionVector = explosionVector.normalise.scale(by: 200 - 2 * distance)
                ball.explosionBoost(by: explosionVector)
            }
            let surroundingPegs = pegsSurrounding(peg).filter { $0.isVisible }
            var greenPegs: [PegGameObject] = []
            var otherPegs: [PegGameObject] = []
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Peg.explodeDelay) {
                for other in surroundingPegs {
                    if other.peg.type == .green {
                        greenPegs.append(other)
                    } else {
                        otherPegs.append(other)
                    }
                }
                self.explodePegs(greenPegs)
                self.removePegs(otherPegs)
            }
        }
    }

    fileprivate func pegsSurrounding(_ peg: PegGameObject) -> [PegGameObject] {
        var surroundingPegs: [PegGameObject] = []
        for other in pegGameObjects where other.peg.position.distance(to: peg.position) <= 100 { // TODO: constant
            surroundingPegs.append(other)
        }
        return surroundingPegs
    }
}
