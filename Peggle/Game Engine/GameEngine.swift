//
//  GameEngine.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation
import SwiftUI

enum GameState {
    case loading
    case active
    case idle
    case lose
    case win
}

class GameEngine: ObservableObject, RendererDelegate {
    let physicsWorld: PhysicsWorld
    var displayLink: CADisplayLink?
    var cannonGameObject: CannonGameObject
    var bucketGameObject: BucketGameObject
    var particleEffectGameObjects: [ParticleEffectGameObject]
    var level: Level

    let selectableCharacters: [GameCharacter] = [KaboomCharacter(), SpookyCharacter()]
    let selectableGameModes: [GameMode] = [NormalMode(), BeatTheScoreMode(), SiamLeftSiamRightMode()]

    @Published var character: GameCharacter?
    @Published var mode: GameMode?
    @Published var currentTime: Date?
    @Published var endTime: Date?
    @Published var lives: Int?
    @Published var bucketShotCount: Int?
    @Published var removedPegs: Set<PegGameObject>
    @Published var state: GameState

    let renderer: Renderer

    init(level: Level, renderer: Renderer) {
        self.level = level
        self.cannonGameObject = CannonGameObject(position: CGPoint(
            x: level.frame.width / 2,
            y: Constants.Cannon.height / 2
        ))
        self.bucketGameObject = BucketGameObject(position: CGPoint(
            x: level.frame.width / 2,
            y: level.frame.height + Constants.Cannon.height + Constants.Bucket.height / 2
        ))
        self.particleEffectGameObjects = []
        let frame = level.frame
            .adjust(y: Constants.Cannon.height)
            .adjust(y: Constants.Bucket.height)
        self.physicsWorld = PhysicsWorld(frame: Frame(width: frame.width, height: frame.height))
        self.state = .loading
        self.removedPegs = []
        self.renderer = renderer
        renderer.gameEngine = self
    }

    deinit {
        renderer.invalidateDisplayLink()
    }
}

extension GameEngine {
    var frame: CGSize {
        CGSize(width: physicsWorld.frame.width, height: physicsWorld.frame.height)
    }

    var score: Int {
        removedPegs.map { $0.peg.score }.reduce(0, +) * removedPegs.count * scoreMultiplier
    }

    private var scoreMultiplier: Int {
        let visibleRedPegsCount = visiblePegs.filter { $0.peg.type == .red }.count
        if visibleRedPegsCount >= 16 {
            return 1
        } else if visibleRedPegsCount >= 11 {
            return 2
        } else if visibleRedPegsCount >= 8 {
            return 3
        } else if visibleRedPegsCount >= 4 {
            return 5
        } else if visibleRedPegsCount >= 1 {
            return 10
        } else {
            return 100
        }
        // TODO: this is stupid
    }

    var isPresetSelected: Bool {
        character != nil && mode != nil
    }

    var ballGameObjects: [BallGameObject] {
        physicsWorld.bodies.compactMap { $0 as? BallGameObject }
    }

    var pegGameObjects: [PegGameObject] {
        physicsWorld.bodies.compactMap { $0 as? PegGameObject }
    }

    var visiblePegs: [PegGameObject] {
        pegGameObjects.filter { $0.isVisible }
    }

    var bluePegsCount: Int {
        visiblePegs.filter { $0.peg.type == .blue }.count
    }

    var redPegsCount: Int {
        visiblePegs.filter { $0.peg.type == .red }.count
    }

    var greenPegsCount: Int {
        visiblePegs.filter { $0.peg.type == .green }.count
    }

    var blockGameObjects: [BlockGameObject] {
        physicsWorld.bodies.compactMap { $0 as? BlockGameObject }
    }

    var collidedPegGameObjects: [PegGameObject] {
        pegGameObjects.filter { $0.hasCollidedWithBall }
    }

    var blockingGameObjects: [any CollidableGameObject] {
        collidingGameObjects.filter { $0.isBlockingBall }
    }

    var isReady: Bool {
        character != nil && mode != nil
    }

    var noLives: Bool {
        lives == 0
    }

    var time: TimeInterval? {
        guard let endTime = endTime,
              let currentTime = currentTime else {
            return nil
        }
        return max(currentTime.distance(to: endTime), 0)
    }

    var noTime: Bool {
        guard let remainingTime = time else {
            return false
        }
        return remainingTime <= 0
    }

    var isGameOver: Bool {
        isInState(.lose) || isInState(.win)
    }

    var collidingGameObjects: [any CollidableGameObject] {
        physicsWorld.collisionData
            .compactMap { $0 as? BodyBodyCollisionData }
            .filter { data in
                ballGameObjects.contains( where: {
                    data.source === $0
                })
            }
            .map { $0.target }
            .compactMap { $0 as? any CollidableGameObject }
    }

    var collidingPegs: [PegGameObject] {
        collidingGameObjects.compactMap { $0 as? PegGameObject }
    }

    var collidingGreenPegs: [PegGameObject] {
        collidingPegs.filter { $0.peg.type == .green }
    }

    var bucketCollidingBalls: [BallGameObject] {
        ballGameObjects.filter { CollisionManager.hasCollisionBetween(bucketGameObject, and: $0) }
    }

    var exitCollidingBalls: [BallGameObject] {
        physicsWorld.collisionData
            .compactMap { $0 as? BodyFrameCollisionData }
            .filter { $0.side == .bottom && $0.source is BallGameObject }
            .compactMap { $0.source as? BallGameObject }
    }
}

extension GameEngine {
    func addPhysicsBody(_ body: any PhysicsBody) {
        physicsWorld.addBody(body)
    }

    func setCharacter(_ character: GameCharacter) {
        self.character = character
    }

    func setGameMode(_ mode: GameMode) {
        self.mode = mode
    }

    func isInState(_ state: GameState) -> Bool {
        self.state == state
    }

    func startGame() {
        guard isPresetSelected else {
            return
        }
        character?.gameEngine = self
        mode?.gameEngine = self

        self.currentTime = Date.now
        if let presetDuration = mode?.presetDuration {
            self.endTime = Date.now + presetDuration
        } else {
            self.endTime = nil
        }

        self.lives = mode?.presetLives
        self.bucketShotCount = mode?.presetBucketShotCount
        self.state = .idle
    }

    func updateGameState(_ state: GameState) {
        self.state = state
    }

    func removeGameObjects(_ gameObjects: [any CollidableGameObject]) {
        gameObjects.forEach { removeGameObject($0) }
    }

    func removeGameObject(_ gameObject: any CollidableGameObject) {
        gameObject.isVisible = false
        if let peg = gameObject as? PegGameObject {
            removedPegs.insert(peg)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Peg.fadeDuration) {
            self.physicsWorld.removeBody(gameObject)
        }
    }

    func addParticleEffect(_ particleEffect: ParticleEffectGameObject) {
        particleEffectGameObjects.append(particleEffect)
        DispatchQueue.main.asyncAfter(deadline: .now() + particleEffect.duration) {
            self.removeParticleEffect(particleEffect)
        }
    }

    func removeParticleEffect(_ particleEffect: ParticleEffectGameObject) {
        particleEffectGameObjects.removeAll(where: { $0 === particleEffect })
    }

    func pegsSurrounding(_ peg: PegGameObject, within radius: Double) -> [PegGameObject] {
        var surroundingPegs: [PegGameObject] = []
        for other in visiblePegs where other !== peg && other.peg.position.distance(to: peg.position) <= radius {
            surroundingPegs.append(other)
        }
        return surroundingPegs
    }
}
