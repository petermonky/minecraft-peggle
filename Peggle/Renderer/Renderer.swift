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
    private var gameEngine: GameEngine

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
        gameEngine.setRenderer(self)
    }

    func initialiseLevelObjects(frame: Frame) {
        gameEngine.initialiseLevel(frame: frame)
    }
}

extension Renderer {
    var goalText: String {
        gameEngine.mode?.goalText ?? ""
    }

    var frame: CGSize {
        gameEngine.frame
    }

    var isGameOver: Bool {
        gameEngine.isGameOver
    }

    var remainingTime: TimeInterval? {
        gameEngine.time
    }

    var remainingLives: Int? {
        gameEngine.lives
    }

    var score: Int {
        gameEngine.score
    }

    var bluePegsCount: Int {
        gameEngine.visiblePegs.filter { $0.peg.type == .blue }.count
    }

    var orangePegsCount: Int {
        gameEngine.visiblePegs.filter { $0.peg.type == .orange }.count
    }

    var greenPegsCount: Int {
        gameEngine.visiblePegs.filter { $0.peg.type == .green }.count
    }
}

extension Renderer {
    func startGameEngine(character: GameCharacter, mode: GameMode) {
        gameEngine.startGame(character: character, mode: mode)
    }

    func isGameInState(_ state: GameState) -> Bool {
        gameEngine.state == state
    }

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

    func updateCannonAngle(position: CGPoint) {
        gameEngine.updateCannonAngle(position: position)
    }

    func addBallTowards(position: CGPoint) {
        gameEngine.addBallTowards(position: position)
    }
}
