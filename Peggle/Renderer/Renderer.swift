//
//  Renderer.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

class Renderer: ObservableObject, GameEngineDelegate {
//    @Published var ballGameView: BallGameView
    @Published var ballGameViews: [BallGameView]
    @Published var pegGameViews: [PegGameView]
    var gameEngine: GameEngine

    // TODO: remove nasty initialisation code here
    init(gameEngine: GameEngine = GameEngine(level: Level(id: nil,
                                                          frame: CGSize(width: 834.0, height: 984.0)))) {
        self.pegGameViews = []
        self.ballGameViews = []
        self.gameEngine = gameEngine
        gameEngine.delegate = self
    }

    func didUpdateWorld(_ physicsWorld: PhysicsWorld) {
        // TODO: let game engine handle
        let pegGameObjects = physicsWorld.bodies.compactMap { $0 as? PegGameObject }
        pegGameViews = pegGameObjects.map { PegGameView(gameObject: $0) }
        let ballGameObjects = physicsWorld.bodies.compactMap { $0 as? BallGameObject }
        ballGameViews = ballGameObjects.map { BallGameView(gameObject: $0) }

//        if let ballGameObject = physicsWorld.bodies.first(where: { $0 is BallGameObject }) as? BallGameObject {
//            ballGameView = BallGameView(gameObject: ballGameObject)
//        }
    }

    func render() {
//        boardView.resetBoard()
//        if let ballView = ballView {
//            boardView.addBallView(ballView)
//        }
//        boardView.addBucketView(bucketView)
//        boardView.addPegViews(pegViews)
//        boardView.addBlockViews(blockViews)
    }
}
