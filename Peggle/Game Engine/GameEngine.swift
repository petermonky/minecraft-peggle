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
    var state: GameState
    weak var delegate: GameEngineDelegate?
    
    init(level: Level) {
        self.cannonGameObject = CannonGameObject(position: CGPoint(x: level.frame.width / 2, y: 100))
        self.physicsWorld = PhysicsWorld(frame: level.frame)
        self.state = .pending

        level.pegs.forEach { peg in
            physicsWorld.addBody(PegGameObject(peg: peg))
        }
//        physicsWorld.addBody(BallGameObject(position: CGPoint(x: 100, y: 200), velocity: CGVector(dx: 0, dy: 0)))
//        for i in 1...8 {
//            physicsWorld.addBody(BallGameObject(position: CGPoint(x: i * 100, y: 100), velocity: CGVector(dx: 0, dy: 0)))
//        }
//
//        physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: 70, y: 300))))
//        physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: 130, y: 300))))
        for i in 1...20 {
            physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: i * 140 - 50, y: 600))))
        }
        for i in 1...8 {
            physicsWorld.addBody(PegGameObject(peg: OrangePeg(position: CGPoint(x: i * 140 - 80, y: 800))))
        }
        for i in 1...8 {
            physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: i * 140 - 80, y: 400))))
        }

        createDisplayLink()
    }

    var ballGameObjects: [BallGameObject] {
        physicsWorld.bodies.compactMap { $0 as? BallGameObject }
    }

    var pegGameObjects: [PegGameObject] {
        physicsWorld.bodies.compactMap { $0 as? PegGameObject }
    }

    func createDisplayLink() {
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .default)
    }

    @objc func step(displaylink: CADisplayLink) {
        let interval = displaylink.targetTimestamp - displaylink.timestamp
        physicsWorld.update(delta: interval)
        delegate?.didUpdateWorld()
    }

    // TODO: refactor angle computation
    func updateCannonAngle(position: CGPoint) {
        let vector = CGVector(from: position, to: cannonGameObject.position)
        let angle = vector.angle(with: .xBasis)
        cannonGameObject.angle = CGFloat.pi / 2 - angle
    }

    func fireBall(position: CGPoint) {
        let vector = CGVector(from: position, to: cannonGameObject.position)
        physicsWorld.addBody(BallGameObject(position: cannonGameObject.position, velocity: vector.normalise.scale(by: -800)))
    }
}
