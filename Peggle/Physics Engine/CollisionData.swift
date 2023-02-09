//
//  CollisionData.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/09.
//

import Foundation

protocol CollisionData: Hashable {
    var sourceId: String { get }
}

struct CircleFrameCollisionData: CollisionData {
    let sourceId: String
    let side: FrameSideType

    init(circleBody: any CircleDynamicPhysicsBody, side: FrameSideType) {
        self.sourceId = circleBody.id
        self.side = side
    }
}

struct CircleCircleCollisionData: CollisionData {
    let sourceId: String
    let targetId: String

    init(first firstCircleBody: any CircleDynamicPhysicsBody, second secondCircleBody: any CirclePhysicsBody) {
        self.sourceId = firstCircleBody.id
        self.targetId = secondCircleBody.id
    }
}
