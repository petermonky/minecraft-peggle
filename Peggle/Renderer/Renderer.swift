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
    @Published private(set) var ballGameViews: [BallGameView]?
    @Published private(set) var pegGameViews: [PegGameView]?
    @Published private(set) var blockGameViews: [BlockGameView]?
    private var gameEngine: GameEngine

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
        gameEngine.setRenderer(self)
    }

    deinit {
        gameEngine.invalidateDisplayLink()
    }

    func initialiseLevelObjects(frame: Frame) {
        gameEngine.initialiseLevel(frame: frame)
    }
}

extension Renderer {

    var frame: CGSize {
        gameEngine.frame
    }
}

extension Renderer {
    func didUpdateWorld() {
        clearViews()
        renderViews()
    }

    func didUpdateGameState() {
//        gameState = gameEngine.state
    }

    func clearViews() {
        cannonGameView = nil
        bucketGameView = nil
        ballGameViews = []
        pegGameViews = []
        blockGameViews = []
    }

    func renderViews() {
        cannonGameView = CannonGameView(gameObject: gameEngine.cannonGameObject)
        bucketGameView = BucketGameView(gameObject: gameEngine.bucketGameObject)
        ballGameViews = gameEngine.ballGameObjects.map { BallGameView(gameObject: $0) }
        pegGameViews = gameEngine.pegGameObjects.map { PegGameView(gameObject: $0) }
        blockGameViews = gameEngine.blockGameObjects.map { BlockGameView(gameObject: $0) }
    }

    func updateCannonAngle(position: CGPoint) {
        gameEngine.updateCannonAngle(position: position)
    }

    func addBallTowards(position: CGPoint) {
        gameEngine.addBallTowards(position: position)
    }
}
