//
//  GameEngine+RendererDelegate.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/26.
//

import Foundation

extension GameEngine {
    func didAppear(frame: Frame) {
        callibrateLevel(frame: frame)
        addLevelObjects()
    }
    
    private func callibrateLevel(frame: Frame) {
        level = level.clone()
        level.scaledToFit(frame: frame.adjust(y: -(Constants.Cannon.height + Constants.Bucket.height)))
        physicsWorld.adjustFrame(x: frame.width - physicsWorld.frame.width, y: frame.height - physicsWorld.frame.height)
    }
    
    private func addLevelObjects() {
        level.pegs.forEach { peg in
            let pegGameObject = PegGameObject(peg: peg)
            let shiftedPosition = pegGameObject.position.move(by: CGVector(dx: 0, dy: Constants.Cannon.height))
            pegGameObject.updatePosition(shiftedPosition)
            pegGameObject.gameEngine = self
            addPhysicsBody(pegGameObject)
        }
        level.blocks.forEach { block in
            let blockGameObject = BlockGameObject(block: block)
            let shiftedPosition = blockGameObject.position.move(by: CGVector(dx: 0, dy: Constants.Cannon.height))
            blockGameObject.updatePosition(shiftedPosition)
            addPhysicsBody(blockGameObject)
        }
        cannonGameObject = CannonGameObject(position: CGPoint(
            x: level.frame.width / 2,
            y: Constants.Cannon.height / 2
        ))
        bucketGameObject = BucketGameObject(position: CGPoint(
            x: level.frame.width / 2,
            y: level.frame.height + Constants.Cannon.height + Constants.Bucket.height / 2
        ))
    }
}

extension GameEngine {
    func didRefreshDisplay(interval: TimeInterval) {
        guard !isGameOver else {
            return
        }
        
        physicsWorld.update(delta: interval)
        updateCurrentTime()
        
        character?.applyPower()
        handleBallGameObjectCollision()
        removeBlockingGameObjects()
        
        handleBallExitCollision()
        handleBallBucketCollision()
        updateBucketMovement(delta: interval)
        
        mode?.handleGameOver()
        refreshGameState()
        
        renderer.clearViews()
        renderer.renderViews()
    }
    
    private func updateCurrentTime() {
        guard !isGameOver else {
            return
        }
        currentTime = Date.now
    }
    
    private func handleBallGameObjectCollision() {
        for gameObject in collidingGameObjects {
            gameObject.collideWithBall()
        }
    }
    
    private func removeBlockingGameObjects() {
        removeGameObjects(blockingGameObjects)
    }
    
    private func handleBallExitCollision() {
        exitCollidingBalls.forEach {
            if $0.isSpooky {
                respawnBall($0)
            } else {
                removeBall($0)
            }
        }
    }
    
    private func handleBallBucketCollision() {
        bucketCollidingBalls.forEach {
            lives? += 1
            bucketShotCount? += 1
            removeBall($0)
        }
    }
    
    private func respawnBall(_ ball: BallGameObject) {
        let newPosition = CGPoint(x: ball.position.x, y: Constants.Ball.radius)
        ball.updatePosition(newPosition)
        ball.unsetSpooky()
    }
    
    private func removeBall(_ ball: BallGameObject) {
        physicsWorld.removeBody(ball)
    }
    
    private func updateBucketMovement(delta interval: TimeInterval) {
        let hasCollisionWithLeft = bucketGameObject.position.x - Constants.Bucket.width / 2 <= 0
        let hasCollisionWithRight = bucketGameObject.position.x + Constants.Bucket.width / 2 >= frame.width
        
        if hasCollisionWithLeft {
            bucketGameObject.updateDirection(to: .right)
        } else if hasCollisionWithRight {
            bucketGameObject.updateDirection(to: .left)
        }
        
        bucketGameObject.moveInDirection(delta: interval)
    }
    
    private func refreshGameState() {
        guard ballGameObjects.isEmpty && isInState(.active) else {
            return
        }
        removeCollidedPegs()
        cannonGameObject.setAvailable()
        updateGameState(.idle)
    }
    
    private func removeCollidedPegs() {
        removeGameObjects(collidedPegGameObjects)
    }
}

extension GameEngine {
    func didUpdateCannonTowards(position: CGPoint) {
        guard isInState(.idle) else {
            return
        }
        let vector = CGVector(from: position, to: cannonGameObject.position)
        let angle = vector.angle(with: .xBasis)
        guard validCannonAngle(angle) else {
            return
        }
        cannonGameObject.angle = (CGFloat.pi / 2 - angle)
    }
    
    private func validCannonAngle(_ angle: CGFloat) -> Bool {
        angle >= 0 && angle <= CGFloat.pi
    }
}

extension GameEngine {
    func didAddBallTowards(position: CGPoint) {
        guard isInState(.idle) else {
            return
        }

        let vector = CGVector(from: position, to: cannonGameObject.position)
        let angle = vector.angle(with: .xBasis)
        guard validCannonAngle(angle) else {
            return
        }

        let normalFromCannonToPosition = vector.normalise.flip
        addPhysicsBody(BallGameObject(
            position: cannonGameObject.position,
            velocity: normalFromCannonToPosition.scale(by: Constants.Ball.initialSpeed))
        )

        if let lives = lives {
            self.lives = max(lives - 1, 0)
        }
        cannonGameObject.setUnavailable()
        updateGameState(.active)
    }
}
