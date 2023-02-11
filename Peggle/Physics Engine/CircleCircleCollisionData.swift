//
//  CircleCircleCollisionData.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

struct CircleCircleCollisionData: CollisionData {
    let sourceId: String
    let targetId: String

    init(first firstCircleBody: any DynamicCirclePhysicsBody, second secondCircleBody: any CirclePhysicsBody) {
        self.sourceId = firstCircleBody.id
        self.targetId = secondCircleBody.id
    }
}
