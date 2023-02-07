//
//  CirclePhysicsBody.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

protocol CirclePhysicsBody: PhysicsBody where Shape == CirclePhysicsShape {
    override var shape: CirclePhysicsShape { get }
}
