//
//  BallGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

final class BallGameObject: ObservableObject, DynamicCirclePhysicsBody {
    @Published var position: CGPoint
    @Published var velocity: CGVector
    @Published var isSpooky: Bool
    let shape: CirclePhysicsShape

    init(
        position: CGPoint = CGPoint.zero,
        velocity: CGVector = CGVector.zero,
        isSpooky: Bool = false,
        shape: Shape = CirclePhysicsShape(radius: Constants.Ball.radius)
    ) {
        self.position = position
        self.velocity = velocity
        self.isSpooky = isSpooky
        self.shape = shape
    }

    init(instance: BallGameObject) {
        position = instance.position
        velocity = instance.velocity
        isSpooky = instance.isSpooky
        shape = instance.shape
    }

    func clone() -> Self {
        Self(instance: self)
    }

    func explosionBoost(by vector: CGVector) {
        velocity = velocity.add(by: vector)
    }

    func setSpooky() {
        isSpooky = true
    }

    func unsetSpooky() {
        isSpooky = false
    }
}
