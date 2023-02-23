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
    case idle
}

class GameEngine {
    let cannonGameObject: CannonGameObject
    let bucketGameObject: BucketGameObject
    let physicsWorld: PhysicsWorld
    private(set) var state: GameState
    weak var delegate: GameEngineDelegate?

    var frame: CGSize {
        CGSize(width: physicsWorld.frame.width, height: physicsWorld.frame.height)
    }

    var ballGameObject: BallGameObject? {
        physicsWorld.bodies.first { $0 is BallGameObject } as? BallGameObject
    }

    var pegGameObjects: [PegGameObject] {
        physicsWorld.bodies.compactMap { $0 as? PegGameObject }
    }

    var blockGameObjects: [BlockGameObject] {
        physicsWorld.bodies.compactMap { $0 as? BlockGameObject }
    }

    var collidedPegGameObjects: [PegGameObject] {
        pegGameObjects.filter { $0.hasCollidedWithBall }
    }

    var blockingPegGameObjects: [PegGameObject] {
        pegGameObjects.filter { $0.isBlockingBall }
    }

    init(level: Level) {
        self.cannonGameObject = CannonGameObject(position: CGPoint(
            x: level.frame.width / 2,
            y: Constants.Cannon.height / 2
        ))
        self.bucketGameObject = BucketGameObject(position: CGPoint(
            x: level.frame.width / 2,
            y: level.frame.height + Constants.Cannon.height + Constants.Bucket.height / 2
        ))
        let frame = level.frame
            .extend(y: Constants.Cannon.height)
            .extend(y: Constants.Bucket.height)
        self.physicsWorld = PhysicsWorld(frame: Frame(width: frame.width, height: frame.height))
        self.state = .idle

        initialiseLevelObjects(level: level)
        createDisplayLink()
    }

    func setDelegate(_ delegate: GameEngineDelegate) {
        self.delegate = delegate
    }

    func isInState(_ state: GameState) -> Bool {
        self.state == state
    }

    private var isGameOver: Bool {
        physicsWorld.collisionData.contains(where: {
            isBallFrameBottomCollision(collisionData: $0 )
        })
    }

    private var ballPegCollisions: [BodyBodyCollisionData] {
        physicsWorld.collisionData
            .compactMap { $0 as? BodyBodyCollisionData }
            .filter { data in
                let sourceIsBall = data.sourceId == ballGameObject?.id
                let targetIsPeg = pegGameObjects.contains(where: {
                    data.targetId == $0.id
                })
                return sourceIsBall && targetIsPeg
            }
    }

    private func isBallFrameBottomCollision(collisionData: any CollisionData) -> Bool {
        if let collisionData = collisionData as? BodyFrameCollisionData,
           collisionData.side == .bottom,
           collisionData.sourceId == ballGameObject?.id {
            return true
        }
        return false
    }

    private func initialiseLevelObjects(level: Level) {
        level.pegs.forEach { peg in
            let pegGameObject = PegGameObject(peg: peg)
            let shiftedPosition = pegGameObject.position.move(by: CGVector(dx: 0, dy: Constants.Cannon.height))
            pegGameObject.updatePosition(shiftedPosition)
            physicsWorld.addBody(pegGameObject)
        }
        level.blocks.forEach { block in
            let blockGameObject = BlockGameObject(block: block)
            let shiftedPosition = blockGameObject.position.move(by: CGVector(dx: 0, dy: Constants.Cannon.height))
            blockGameObject.updatePosition(shiftedPosition)
            physicsWorld.addBody(blockGameObject)
        }
    }

    private func createDisplayLink() {
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .default)
    }

    @objc func step(displaylink: CADisplayLink) {
        let interval = displaylink.targetTimestamp - displaylink.timestamp
        physicsWorld.update(delta: interval)

        lightCollidingPegs()
        removeBlockingPegs()
        handleGameOver()
        delegate?.didUpdateWorld(
            cannonGameObject: cannonGameObject,
            bucketGameObject: bucketGameObject,
            ballGameObject: ballGameObject,
            pegGameObjects: pegGameObjects,
            blockGameObjects: blockGameObjects
        )
    }

    private func updateGameState(_ state: GameState) {
        self.state = state
    }

    private func lightCollidingPegs() {
        for peg in pegGameObjects where ballPegCollisions.contains(where: {
            $0.targetId == peg.id
        }) {
            peg.collideWithBall()
        }
    }

    private func removeBlockingPegs() {
        removePegs(blockingPegGameObjects)
    }

    private func handleGameOver() {
        guard isGameOver else {
            return
        }

        removeCollidedPegs()
        removeExitedBall()
        cannonGameObject.setAvailable()
        updateGameState(.idle)

        delegate?.didGameOver()
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

        cannonGameObject.setUnavailable()
        updateGameState(.active)
    }
}
