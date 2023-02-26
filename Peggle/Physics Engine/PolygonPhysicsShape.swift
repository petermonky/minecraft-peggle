//
//  PolygonPhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

struct PolygonPhysicsShape: PhysicsShape {
    var vertices: [CGPoint]
    var rotation: CGFloat
    var width: CGFloat
    var height: CGFloat

    init(vertices: [CGPoint] = [], rotation: CGFloat = 0) {
        self.vertices = vertices
        self.rotation = rotation

        var minX = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude

        for vertex in vertices {
            if vertex.x < minX {
                minX = vertex.x
            }
            if vertex.x > maxX {
                maxX = vertex.x
            }
            if vertex.y < minY {
                minY = vertex.y
            }
            if vertex.y > maxY {
                maxY = vertex.y
            }
        }

        self.width = maxX - minX
        self.height = maxY - minY
    }

    init(width: CGFloat, height: CGFloat, rotation: CGFloat = 0) {
        let topLeft     = CGPoint.zero.move(by: CGVector(dx: -width / 2, dy: -height / 2).rotate(by: rotation))
        let topRight    = CGPoint.zero.move(by: CGVector(dx: width / 2, dy: -height / 2).rotate(by: rotation))
        let bottomLeft  = CGPoint.zero.move(by: CGVector(dx: width / 2, dy: height / 2).rotate(by: rotation))
        let bottomRight = CGPoint.zero.move(by: CGVector(dx: -width / 2, dy: height / 2).rotate(by: rotation))
        self.vertices = [topLeft, topRight, bottomLeft, bottomRight]
        self.width = width
        self.height = height
        self.rotation = rotation
    }

    mutating func scale(by value: CGFloat) {
        width *= value
        height *= value
        vertices = vertices.map {
            let centerToVertex = CGVector(from: center, to: $0)
            let scaled = centerToVertex.scale(by: value)
            return CGPoint(x: scaled.dx, y: scaled.dy)
        }
    }

    mutating func rotate(by value: CGFloat) {
        rotation += value
        vertices = vertices.map { $0.rotate(by: value, about: center) }
    }
}
