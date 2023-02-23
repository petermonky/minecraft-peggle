//
//  File.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

struct BodyFrameCollisionData: CollisionData {
    let sourceId: String
    let side: FrameSide

    init(body: any DynamicPhysicsBody, side: FrameSide) {
        self.sourceId = body.id
        self.side = side
    }
}
