//
//  Renderer.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

class Renderer: ObservableObject, GameEngineDelegate {
    @Published private(set) var cannonGameView: CannonGameView?
    @Published private(set) var bucketGameView: BucketGameView?
    @Published private(set) var ballGameView: BallGameView?
    @Published private(set) var pegGameViews: [PegGameView]?
    @Published private(set) var blockGameViews: [BlockGameView]?
    @Published private(set) var isGameOverModalPresent: Bool
    private var gameEngine: GameEngine

    var frame: CGSize {
        gameEngine.frame
    }

    var remainingTime: TimeInterval? {
        if let endTime = gameEngine.endTime {
            return Date.now.distance(to: endTime)
        }
        return nil
    }

    var remainingLives: Int? {
        gameEngine.lives
    }

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
        self.isGameOverModalPresent = false
        gameEngine.setRenderer(self)
    }

    func didUpdateWorld() {
        clearViews()
        renderViews()
    }

    // TODO: add game over logic
    func didGameOver() {
        isGameOverModalPresent = true
    }

    func clearViews() {
        cannonGameView = nil
        bucketGameView = nil
        ballGameView = nil
        pegGameViews = nil
        blockGameViews = nil
    }

    func renderViews() {
        if let ballGameObject = gameEngine.ballGameObject {
            ballGameView = BallGameView(gameObject: ballGameObject)
        }
        cannonGameView = CannonGameView(gameObject: gameEngine.cannonGameObject)
        bucketGameView = BucketGameView(gameObject: gameEngine.bucketGameObject)
        pegGameViews = gameEngine.pegGameObjects.map { PegGameView(gameObject: $0) }
        blockGameViews = gameEngine.blockGameObjects.map { BlockGameView(gameObject: $0) }
    }
}
