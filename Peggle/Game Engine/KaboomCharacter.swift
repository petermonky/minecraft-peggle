//
//  KaboomCharacter.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

class KaboomCharacter: GameCharacter {
    weak var gameEngine: GameEngine?
    let name: String = "Ka-Boom"
    let description: String = """
    Who needs strategy when you have explosives? \
    Watch as the green peg and its friends go out \
    with a bang, and the ball gets knocked off \
    course!
    """

    func applyPower() {
        guard let gameEngine = gameEngine else {
            return
        }
        explodePegs(gameEngine.collidingGreenPegs)
    }

    private func explodePegs(_ pegs: [PegGameObject]) {
        guard let gameEngine = gameEngine else {
            return
        }
        let pegs = pegs.filter { $0.isVisible }
        gameEngine.removeGameObjects(pegs)
        chainExplosion(around: pegs)
    }

    private func chainExplosion(around pegs: [PegGameObject]) {
        for peg in pegs {
            addExplosionEffect(at: peg)
            explosionBoostBalls(around: peg)
            cascadeExplosion(around: peg)
        }
    }

    private func addExplosionEffect(at peg: PegGameObject) {
        gameEngine?.addParticleEffect(ParticleEffectGameObject(
            position: peg.position,
            imageName: "explosion",
            duration: 0.5
        ))
    }

    private func explosionBoostBalls(around peg: PegGameObject) {
        gameEngine?.ballGameObjects.forEach { ball in
            let distance = peg.position.distance(to: ball.position)
            if distance <= Constants.Kaboom.radius {
                var explosionVector = CGVector(from: peg.position, to: ball.position)
                explosionVector = explosionVector.normalise.scale(by: 5 * (Constants.Kaboom.radius - distance))
                ball.explosionBoost(by: explosionVector)
            }
        }
    }

    private func cascadeExplosion(around peg: PegGameObject) {
        guard let gameEngine = gameEngine else {
            return
        }
        let surroundingPegs = gameEngine.pegsSurrounding(peg, within: Constants.Kaboom.radius)
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
            gameEngine.removeGameObjects(otherPegs)
        }
    }
}
