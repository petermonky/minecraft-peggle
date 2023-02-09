//
//  GameEngine.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation
import SwiftUI

enum GameState {
    case active
    case pending
}

class GameEngine {
    let cannonGameObject: CannonGameObject
    let physicsWorld: PhysicsWorld
    private(set) var state: GameState
    weak var delegate: GameEngineDelegate?

    var frame: CGSize {
        physicsWorld.frame
    }

    var ballGameObject: BallGameObject? {
        physicsWorld.bodies.first { $0 is BallGameObject } as? BallGameObject
    }

    var pegGameObjects: [PegGameObject] {
        physicsWorld.bodies.compactMap { $0 as? PegGameObject }
    }

    var collidedPegGameObjects: [PegGameObject] {
        pegGameObjects.filter { $0.hasCollidedWithBall }
    }

    // TODO: use collisiondata ??
    var blockingPegGameObjects: [PegGameObject] {
        pegGameObjects.filter { $0.isBlockingBall }
    }

    init(level: Level) {
        self.cannonGameObject = CannonGameObject(position: CGPoint(
            x: level.frame.width / 2,
            y: Constants.Cannon.height / 2)
        )
        self.physicsWorld = PhysicsWorld(frame: level.frame.extend(y: Constants.Cannon.height))
        self.state = .pending

        initialisePegs(level: level)
        createDisplayLink()
    }

    func isInState(_ state: GameState) -> Bool {
        self.state == state
    }

    private var isGameOver: Bool {
        physicsWorld.collisionData.contains(where: {
            isBallFrameBottomCollision(collisionData: $0 )
        })
    }

    private func isBallFrameBottomCollision(collisionData: any CollisionData) -> Bool {
        if let collisionData = collisionData as? CircleFrameCollisionData,
           collisionData.side == .bottom,
           collisionData.sourceId == ballGameObject?.id {
            return true
        }
        return false
    }

    private func initialisePegs(level: Level) {
        level.pegs.forEach { peg in
            let pegGameObject = PegGameObject(peg: peg)
            let shiftedPosition = pegGameObject.position.move(by: CGVector(dx: 0, dy: Constants.Cannon.height))
            pegGameObject.updatePosition(shiftedPosition)
            physicsWorld.addBody(pegGameObject)
        }
    }

    private func createDisplayLink() {
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .default)
    }

    @objc func step(displaylink: CADisplayLink) {
        let interval = displaylink.targetTimestamp - displaylink.timestamp
        physicsWorld.update(delta: interval)

        removeBlockingPegs()
        handleGameOver()
        delegate?.didUpdateWorld()
    }

    private func updateGameState(_ state: GameState) {
        self.state = state
    }

    private func handleGameOver() {
        guard isGameOver else {
            return
        }

        removeCollidedPegs()
        removeExitedBall()
        updateGameState(.pending)

        delegate?.didGameOver()
    }

    private func removeBlockingPegs() {
        removePegs(blockingPegGameObjects)
    }

    private func removeCollidedPegs() {
        removePegs(collidedPegGameObjects)
    }

    private func removePegs(_ pegs: [PegGameObject]) {
        pegs.forEach { $0.isVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Peg.fadeDuration) {
            pegs.forEach { self.physicsWorld.removeBody($0) }
        }
    }

    private func removeExitedBall() {
        guard let ballGameObject = ballGameObject else {
            return
        }
        physicsWorld.removeBody(ballGameObject)
    }

    private func validCannonAngle(_ angle: CGFloat) -> Bool {
        angle >= 0 && angle <= CGFloat.pi
    }

    func updateCannonAngle(position: CGPoint) {
        let vector = CGVector(from: position, to: cannonGameObject.position)
        let angle = vector.angle(with: .xBasis)
        guard validCannonAngle(angle) else {
            return
        }
        cannonGameObject.angle = (CGFloat.pi / 2 - angle)
    }

    func addBallTowards(position: CGPoint) {
        let vector = CGVector(from: position, to: cannonGameObject.position)
        let angle = vector.angle(with: .xBasis)
        guard validCannonAngle(angle) else {
            return
        }
        let normalFromCannonToPosition = vector.normalise.flip
        physicsWorld.addBody(BallGameObject(
            position: cannonGameObject.position,
            velocity: normalFromCannonToPosition.scale(by: Constants.Ball.initialSpeed))
        )
        updateGameState(.active)
    }
}
