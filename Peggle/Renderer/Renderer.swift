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

    var frame: CGSize {
        gameEngine.frame
    }

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
        gameEngine.delegate = self
    }

    func didUpdateWorld() {
        clearViews()
        renderViews()
    }

    // TODO: add game over logic
    func didGameOver() {
        print("Game over")
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
        guard gameEngine.isInState(.pending) else {
            return
        }
        gameEngine.updateCannonAngle(position: position)
    }

    func fireBall(position: CGPoint) {
        guard gameEngine.isInState(.pending) else {
            return
        }
        gameEngine.addBallTowards(position: position)
    }
}
