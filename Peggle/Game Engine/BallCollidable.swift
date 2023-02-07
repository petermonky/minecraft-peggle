//
//  BallCollidable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import Foundation

protocol BallCollidable {
    mutating func resolvedCollisionWithBall(_ ball: BallGameObject?)
}
