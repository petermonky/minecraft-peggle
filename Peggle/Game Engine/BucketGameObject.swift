//
//  BucketGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation

enum BucketDirection {
    case left
    case right
}

final class BucketGameObject: GameObject, PolygonCollidable {
    @Published private(set) var position: CGPoint
    var direction: BucketDirection
    var shape: PolygonPhysicsShape

    init(position: CGPoint = CGPoint.zero) {
        self.position = position
        self.shape = PolygonPhysicsShape(
            width: Constants.Bucket.width,
            height: Constants.Bucket.height
        )
        self.direction = .right
    }

    func moveInDirection() {
        switch direction {
        case .left:
            position.x -= 2 // TODO: move to constants
        case .right:
            position.x += 2
        }
    }

    func updateDirection(to direction: BucketDirection) {
        self.direction = direction
    }
}
