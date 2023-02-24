//
//  CircleCircleCollisionData.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

class BodyBodyCollisionData: CollisionData, Hashable {
    let source: any DynamicPhysicsBody
    let target: any PhysicsBody

    init(source: any DynamicPhysicsBody, target: any PhysicsBody) {
        self.source = source
        self.target = target
    }
}

extension BodyBodyCollisionData {
    public static func == (lhs: BodyBodyCollisionData, rhs: BodyBodyCollisionData) -> Bool {
        lhs.source === rhs.source && lhs.target === rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(source.id)
        hasher.combine(target.id)
    }
}
