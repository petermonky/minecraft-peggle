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
    @Published private(set) var ballGameView: BallGameView?
    @Published private(set) var pegGameViews: [PegGameView]?
    private var gameEngine: GameEngine

    // TODO: remove nasty initialisation code here
    init(gameEngine: GameEngine = GameEngine(level: Level(id: nil, frame: CGSize(width: 834.0, height: 984.0)))) {
        self.gameEngine = gameEngine
        gameEngine.delegate = self
    }

    func didUpdateWorld() {
        clearViews()
        renderViews()
    }

    func didGameOver() {
//        pegGameViews?.forEach {
//            $0.isVisible = false
//        }
    }

    func clearViews() {
        cannonGameView = nil
        ballGameView = nil
        pegGameViews = nil
    }

    func renderViews() {
        cannonGameView = CannonGameView(gameObject: gameEngine.cannonGameObject)

        let pegGameObjects = gameEngine.pegGameObjects
        pegGameViews = pegGameObjects.map { PegGameView(gameObject: $0) }

        if let ballGameObject = gameEngine.ballGameObject {
            ballGameView = BallGameView(gameObject: ballGameObject)
        }
    }

    func updateCannonAngle(position: CGPoint) {
        gameEngine.updateCannonAngle(position: position)
    }

    func fireBall(position: CGPoint) {
        gameEngine.fireBall(position: position)
    }
}
