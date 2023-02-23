//
//  DynamicBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

enum FrameSide: CaseIterable {
    case left
    case right
    case top
    case bottom
}

protocol DynamicPhysicsBody: PhysicsBody where Body == Self {
    associatedtype Body: PhysicsBody

    override var velocity: CGVector { get set }

    func updateVelocity(_ velocity: CGVector)
}

extension DynamicPhysicsBody {
    func updateVelocity(_ velocity: CGVector) {
        self.velocity = velocity
    }
}
