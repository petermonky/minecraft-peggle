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
    case loading
    case pending
}

class GameEngine {
    let cannonGameObject: CannonGameObject
    let physicsWorld: PhysicsWorld
    private(set) var state: GameState
    weak var delegate: GameEngineDelegate?

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
        self.cannonGameObject = CannonGameObject(position: CGPoint(x: level.frame.width / 2, y: 100))
        self.physicsWorld = PhysicsWorld(frame: level.frame)
        self.state = .pending

        level.pegs.forEach { peg in
            physicsWorld.addBody(PegGameObject(peg: peg))
        }
        for i in 1...20 {
            physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: i * 110 - 50, y: 600))))
        }
        for i in 1...8 {
            physicsWorld.addBody(PegGameObject(peg: OrangePeg(position: CGPoint(x: i * 110 - 80, y: 800))))
        }
        for i in 1...8 {
            physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: i * 125 - 80, y: 400))))
        }

        createDisplayLink()
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

    func createDisplayLink() {
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

        delegate?.didGameOver()
        updateGameState(.pending)
    }

    private func removeBlockingPegs() {
        removePegs(blockingPegGameObjects)
    }

    private func removeCollidedPegs() {
        removePegs(collidedPegGameObjects)
    }

    private func removePegs(_ pegs: [PegGameObject]) {
        pegs.forEach { $0.isVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            pegs.forEach { self.physicsWorld.removeBody($0) }
        }
    }

    private func removeExitedBall() {
        guard let ballGameObject = ballGameObject else {
            return
        }
        physicsWorld.removeBody(ballGameObject)
    }

    func updateCannonAngle(position: CGPoint) {
        let vector = CGVector(from: position, to: cannonGameObject.position)
        let angle = vector.angle(with: .xBasis)
        cannonGameObject.angle = CGFloat.pi / 2 - angle
    }

    func fireBall(position: CGPoint) {
        let vector = CGVector(from: position, to: cannonGameObject.position)
        physicsWorld.addBody(BallGameObject(position: cannonGameObject.position, velocity: vector.normalise.scale(by: -800)))
        updateGameState(.active)
    }
}
