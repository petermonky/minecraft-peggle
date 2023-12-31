//
//  PhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import Foundation

protocol PhysicsShape: Equatable, Codable {
    var center: CGPoint { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
    var rotation: CGFloat { get }

    mutating func scale(by value: CGFloat)
    mutating func rotate(by value: CGFloat)
}

extension PhysicsShape {
    var center: CGPoint {
        CGPoint.zero
    }
}
