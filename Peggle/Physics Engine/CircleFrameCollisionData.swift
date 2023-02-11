//
//  File.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

struct CircleFrameCollisionData: CollisionData {
    let sourceId: String
    let side: FrameSide

    init(circleBody: any DynamicCirclePhysicsBody, side: FrameSide) {
        self.sourceId = circleBody.id
        self.side = side
    }
}
