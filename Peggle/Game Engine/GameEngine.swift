//
//  GameEngine.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation
import SwiftUI

class GameEngine {
    var physicsWorld: PhysicsWorld
    weak var delegate: GameEngineDelegate?

    init(level: Level) {
        self.physicsWorld = PhysicsWorld(frame: level.frame)

        level.pegs.forEach { peg in
            physicsWorld.addBody(PegGameObject(peg: peg))
        }
//        physicsWorld.addBody(BallGameObject(position: CGPoint(x: 100, y: 200), velocity: CGVector(dx: 0, dy: 0)))
//        physicsWorld.addBody(BallGameObject(position: CGPoint(x: 100, y: 100), velocity: CGVector(dx: 0, dy: 0)))
        for i in 1...8 {
            physicsWorld.addBody(BallGameObject(position: CGPoint(x: i * 100, y: 100), velocity: CGVector(dx: 0, dy: 0)))
        }
//
//        physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: 70, y: 300))))
//        physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: 130, y: 300))))
        for i in 1...20 {
            physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: i * 60 - 50, y: 600))))
        }
        for i in 1...8 {
            physicsWorld.addBody(PegGameObject(peg: BluePeg(position: CGPoint(x: i * 120 - 80, y: 800))))
        }

        createDisplayLink()
    }

    func createDisplayLink() {
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .default)
    }

    @objc func step(displaylink: CADisplayLink) {
        let interval = displaylink.targetTimestamp - displaylink.timestamp
        physicsWorld.update(delta: interval)
        delegate?.didUpdateWorld(physicsWorld)
    }
}
