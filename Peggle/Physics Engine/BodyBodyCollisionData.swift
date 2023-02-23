//
//  CircleCircleCollisionData.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

struct BodyBodyCollisionData: CollisionData {
    let sourceId: String
    let targetId: String

    init(body1: any DynamicPhysicsBody, body2: any PhysicsBody) {
        self.sourceId = body1.id
        self.targetId = body2.id
    }
}
