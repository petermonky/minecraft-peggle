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
    let level: Level

    private(set) var character: GameCharacter?
    private(set) var mode: GameMode?
    private(set) var currentTime: Date?
    private(set) var endTime: Date?
    private(set) var lives: Int?
    private(set) var state: GameState
    private(set) var removedPegs: Set<PegGameObject>

    weak var renderer: Renderer?

    init(level: Level) {
        self.level = level
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
        self.removedPegs = []

        initialiseLevelObjects(level: level)
        createDisplayLink()
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
}

extension GameEngine {
    var frame: CGSize {
        CGSize(width: physicsWorld.frame.width, height: physicsWorld.frame.height)
    }

    var score: Int {
        removedPegs.map { $0.peg.score }.reduce(0, +) * removedPegs.count * scoreMultiplier
    }

    private var scoreMultiplier: Int {
        let visibleOrangePegsCount = visiblePegs.filter { $0.peg.type == .orange }.count
        if visibleOrangePegsCount >= 16 {
            return 1
        } else if visibleOrangePegsCount >= 11 {
            return 2
        } else if visibleOrangePegsCount >= 8 {
            return 3
        } else if visibleOrangePegsCount >= 4 {
            return 5
        } else if visibleOrangePegsCount >= 1 {
            return 10
        } else {
            return 100
        }
        // TODO: this is stupid
    }

    var ballGameObject: BallGameObject? {
        physicsWorld.bodies.first { $0 is BallGameObject } as? BallGameObject
    }

    var pegGameObjects: [PegGameObject] {
        physicsWorld.bodies.compactMap { $0 as? PegGameObject }
    }

    var visiblePegs: [PegGameObject] {
        pegGameObjects.filter { $0.isVisible }
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

    var isReady: Bool {
        character != nil && mode != nil
    }

    var noLives: Bool {
        lives == 0
    }

    var time: TimeInterval? {
        guard let endTime = endTime,
              let currentTime = currentTime else {
            return nil
        }
        return currentTime.distance(to: endTime)
    }

    var noTime: Bool {
        guard let remainingTime = time else {
            return false
        }
        return remainingTime <= 0
    }

    var isGameOver: Bool {
        isInState(.lose) || isInState(.win)
    }

    var collidingPegs: [PegGameObject] {
        physicsWorld.collisionData
            .compactMap { $0 as? BodyBodyCollisionData }
            .filter { data in
                let sourceIsBall = data.source === ballGameObject
                let targetIsPeg = pegGameObjects.contains(where: {
                    data.target === $0
                })
                return sourceIsBall && targetIsPeg
            }
            .map { $0.target }
            .compactMap { $0 as? PegGameObject }
    }

    var collidingGreenPegs: [PegGameObject] {
        collidingPegs.filter { $0.peg.type == .green }
    }

    var hasBallBucketCollision: Bool {
        guard let ballGameObject = ballGameObject else {
            return false
        }
        return CollisionManager.hasCollisionBetween(bucketGameObject, and: ballGameObject)
    }
}

extension GameEngine {
    func setRenderer(_ renderer: Renderer) {
        self.renderer = renderer
    }

    func isInState(_ state: GameState) -> Bool {
        self.state == state
    }

    func startGame(character: GameCharacter, mode: GameMode) {
        self.character = character
        character.gameEngine = self

        self.mode = mode
        mode.gameEngine = self

        self.currentTime = Date.now
        if let presetDuration = mode.presetDuration {
            self.endTime = Date.now + presetDuration
        } else {
            self.endTime = nil
        }

        self.lives = mode.presetLives
        self.state = .idle
    }

    private func isBallExitCollision(collisionData: any CollisionData) -> Bool {
        if let collisionData = collisionData as? BodyFrameCollisionData,
           collisionData.side == .bottom,
           collisionData.source === ballGameObject {
            return true
        }
        return false
    }

    @objc func step(displaylink: CADisplayLink) {
        guard !isGameOver else {
            return
        }

        physicsWorld.update(delta: displaylink.targetTimestamp - displaylink.timestamp)
        updateCurrentTime()

        character?.applyPower()
        lightCollidingPegs()
        removeBlockingPegs()

        handleBallBucketCollision()
        updateBucketMovement()
        handleBallExitCollision()

        renderer?.didUpdateWorld()
        if !isGameOver {
            mode?.handleGameOver()
        }
    }

    private func updateCurrentTime() {
        guard !isGameOver else {
            return
        }
        currentTime = Date.now
    }

    private func handleBallBucketCollision() {
        if hasBallBucketCollision {
            refreshGameState()
            lives? += 1
        }
    }

    private func handleBallExitCollision() {
        let hasBallExitCollision = physicsWorld.collisionData.contains(where: {
            isBallExitCollision(collisionData: $0)
        })
        guard hasBallExitCollision else {
            return
        }
        if let ball = ballGameObject, ball.isSpooky {
            respawnBall()
        } else {
            refreshGameState()
        }
    }

    private func respawnBall() {
        guard let ball = ballGameObject else {
            return
        }
        let newPosition = CGPoint(x: ball.position.x, y: Constants.Ball.radius)
        ball.updatePosition(newPosition)
        ball.unsetSpooky()
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

    func updateGameState(_ state: GameState) {
        self.state = state
        renderer?.didUpdateGameState()
    }

    private func lightCollidingPegs() {
        for peg in collidingPegs {
            peg.collideWithBall()
        }
    }

    private func removeBlockingPegs() {
        removePegs(blockingPegGameObjects)
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
        pegs.forEach {
            $0.isVisible = false
            removedPegs.insert($0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Peg.fadeDuration) {
            pegs.forEach { self.physicsWorld.removeBody($0) }
        }
    }

    func pegsSurrounding(_ peg: PegGameObject, within radius: Double) -> [PegGameObject] {
        var surroundingPegs: [PegGameObject] = []
        for other in visiblePegs where other.peg.position.distance(to: peg.position) <= radius { // TODO: constant
            surroundingPegs.append(other)
        }
        return surroundingPegs
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

        if let lives = lives {
            self.lives = max(lives - 1, 0)
        }
        cannonGameObject.setUnavailable()
        updateGameState(.active)
    }
}
