//
//  Renderer.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

class Renderer: ObservableObject, GameEngineDelegate {
    // TODO: remove gameObject from view. stop riding mvvm !!
    @Published private(set) var cannonGameView: CannonGameView?
    @Published private(set) var ballGameViews: [BallGameView]?
    @Published private(set) var pegGameViews: [PegGameView]?
    private var gameEngine: GameEngine

    // TODO: remove nasty initialisation code here
    init(gameEngine: GameEngine = GameEngine(level: Level(id: nil,
                                                          frame: CGSize(width: 834.0, height: 984.0)))) {
        self.cannonGameView = CannonGameView(gameObject: gameEngine.cannonGameObject)
        self.gameEngine = gameEngine

        gameEngine.delegate = self
    }

    func didUpdateWorld() {
        render()
    }

    func render() {
        // TODO: let game engine handle
        cannonGameView = CannonGameView(gameObject: gameEngine.cannonGameObject)

        let pegGameObjects = gameEngine.pegGameObjects
        pegGameViews = pegGameObjects.map { PegGameView(gameObject: $0) }

        let ballGameObjects = gameEngine.ballGameObjects
        ballGameViews = ballGameObjects.map { BallGameView(gameObject: $0) }

        print(pegGameObjects.filter { $0.hasCollidedWithBall })

//        if let ballGameObject = gameEngine.physicsWorld.bodies
//            .first(where: { $0 is BallGameObject }) as? BallGameObject {
//            ballGameView = BallGameView(gameObject: ballGameObject)
//        }
    }

    func updateCannonAngle(position: CGPoint) {
        gameEngine.updateCannonAngle(position: position)
    }

    func fireBall(position: CGPoint) {
        gameEngine.fireBall(position: position)
    }
}
