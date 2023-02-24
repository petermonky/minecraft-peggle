//
//  GameEngine.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation
import SwiftUI

enum GameState {
    case loading
    case active
    case idle
    case lose
    case win
}

class GameEngine {
    let cannonGameObject: CannonGameObject
    let bucketGameObject: BucketGameObject
    let physicsWorld: PhysicsWorld

    private(set) var character: GameCharacter?
    private(set) var endTime: Date?
    private(set) var lives: Int?
    private(set) var state: GameState

    private weak var renderer: Renderer?

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

    var collidedGreenPegGameObjects: [PegGameObject] {
        collidedPegGameObjects.filter { $0.peg.type == .green }
    }

    var blockingPegGameObjects: [PegGameObject] {
        pegGameObjects.filter { $0.isBlockingBall }
    }

    var isGameOver: Bool {
        lives == 0
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
            .adjust(y: Constants.Cannon.height)
            .adjust(y: Constants.Bucket.height)
        self.physicsWorld = PhysicsWorld(frame: Frame(width: frame.width, height: frame.height))
        self.state = .loading

        initialiseLevelObjects(level: level)
        createDisplayLink()
    }

    func setRenderer(_ renderer: Renderer) {
        self.renderer = renderer
    }

    func isInState(_ state: GameState) -> Bool {
        self.state == state
    }

    func startGame(character: GameCharacter) {
        self.character = character
        self.endTime = Date.now + 10
        self.lives = 1
        self.state = .idle
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

        handleBallEnterBucket()
        updateBucketMovement()
        handleBallExitLevel()

        character?.applyPower(gameEngine: self)
        renderer?.didUpdateWorld()
    }

    private func handleBallEnterBucket() {
        guard let ballGameObject = ballGameObject else {
            return
        }
        if CollisionManager.hasCollisionBetween(bucketGameObject, and: ballGameObject) {
            refreshGameState()
            lives? += 1
        }
    }

    private func handleBallExitLevel() {
        if physicsWorld.collisionData.contains(where: {
            isBallFrameBottomCollision(collisionData: $0 )
        }) {
            refreshGameState()
            handleGameOver()
        }
    }

    private func updateBucketMovement() {
        let hasCollisionWithLeft = bucketGameObject.position.x - Constants.Bucket.width / 2 <= 0
        let hasCollisionWithRight = bucketGameObject.position.x + Constants.Bucket.width / 2 >= frame.width

        if hasCollisionWithLeft {
            bucketGameObject.updateDirection(to: .right)
        } else if hasCollisionWithRight {
            bucketGameObject.updateDirection(to: .left)
        }

        bucketGameObject.moveInDirection()
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
        if isGameOver {
            updateGameState(.lose)
            renderer?.didGameOver()
        }
    }

    private func refreshGameState() {
        removeCollidedPegs()
        removeExitedBall()
        cannonGameObject.setAvailable()
        updateGameState(.idle)
    }

    private func removeCollidedPegs() {
        removePegs(collidedPegGameObjects)
    }

    func removePegs(_ pegs: [PegGameObject]) {
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
        guard isInState(.idle) else {
            return
        }
        let vector = CGVector(from: position, to: cannonGameObject.position)
        let angle = vector.angle(with: .xBasis)
        guard validCannonAngle(angle) else {
            return
        }
        cannonGameObject.angle = (CGFloat.pi / 2 - angle)
    }

    func addBallTowards(position: CGPoint) {
        guard isInState(.idle) else {
            return
        }

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

        lives? -= 1
        cannonGameObject.setUnavailable()
        updateGameState(.active)
    }
}
