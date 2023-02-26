//
//  Renderer.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation
import SwiftUI

class Renderer: ObservableObject {
    @Published private(set) var cannonGameView: CannonGameView?
    @Published private(set) var bucketGameView: BucketGameView?
    @Published private(set) var ballGameViews: [BallGameView]?
    @Published private(set) var pegGameViews: [PegGameView]?
    @Published private(set) var blockGameViews: [BlockGameView]?
    @Published private(set) var particleEffectViews: [ParticleEffectView]?
    private var displayLink: CADisplayLink?
    weak var gameEngine: GameEngine?

    init() {
        createDisplayLink()
    }

    func invalidateDisplayLink() {
        self.displayLink?.invalidate()
    }

    private func createDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink?.add(to: .current, forMode: .default)
    }

    func initialiseLevelObjects(frame: Frame) {
        gameEngine?.didAppear(frame: frame)
    }

    @objc func step(displaylink: CADisplayLink) {
        guard let gameEngine = gameEngine,
              let displayLink = displayLink else {
            return
        }
        let interval = displayLink.targetTimestamp - displayLink.timestamp
        gameEngine.didRefreshDisplay(interval: interval)
    }
}

extension Renderer {
    var frame: CGSize {
        gameEngine?.frame ?? .zero
    }
}

extension Renderer {
    func clearViews() {
        cannonGameView = nil
        bucketGameView = nil
        ballGameViews = []
        pegGameViews = []
        blockGameViews = []
        particleEffectViews = []
    }

    func renderViews() {
        guard let gameEngine = gameEngine else {
            return
        }
        cannonGameView = CannonGameView(gameObject: gameEngine.cannonGameObject)
        bucketGameView = BucketGameView(gameObject: gameEngine.bucketGameObject)
        ballGameViews = gameEngine.ballGameObjects.map { BallGameView(gameObject: $0) }
        pegGameViews = gameEngine.pegGameObjects.map { PegGameView(gameObject: $0) }
        blockGameViews = gameEngine.blockGameObjects.map { BlockGameView(gameObject: $0) }
        particleEffectViews = gameEngine.particleEffectGameObjects.map { ParticleEffectView(gameObject: $0) }
    }

    func updateCannonAngle(position: CGPoint) {
        gameEngine?.didUpdateCannonTowards(position: position)
    }

    func addBallTowards(position: CGPoint) {
        gameEngine?.didAddBallTowards(position: position)
    }
}
