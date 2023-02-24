//
//  File.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/12.
//

import Foundation

class BodyFrameCollisionData: CollisionData, Hashable {
    let source: any DynamicPhysicsBody
    let side: FrameSide

    init(body: any DynamicPhysicsBody, side: FrameSide) {
        self.source = body
        self.side = side
    }
}

extension BodyFrameCollisionData {
    static func == (lhs: BodyFrameCollisionData, rhs: BodyFrameCollisionData) -> Bool {
        lhs.source === rhs.source && lhs.side == rhs.side
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(source.id)
        hasher.combine(side)
    }
}
