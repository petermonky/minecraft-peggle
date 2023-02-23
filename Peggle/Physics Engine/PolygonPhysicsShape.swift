//
//  PolygonPhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

struct PolygonPhysicsShape: PhysicsShape {
    var vertices: [CGPoint]
    var width: CGFloat
    var height: CGFloat

    init(vertices: [CGPoint] = [
        CGPoint(x: -1, y: -1),
        CGPoint(x: -1, y: 1),
        CGPoint(x: 1, y: -1),
        CGPoint(x: 1, y: 1)
    ]) {
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude

        for vertex in vertices {
            if vertex.x < minX {
                minX = vertex.x
            }
            if vertex.y < minY {
                minY = vertex.y
            }
            if vertex.x > maxX {
                maxX = vertex.x
            }
            if vertex.y > maxY {
                maxY = vertex.y
            }
        }

        self.width = maxX - minX
        self.height = maxY - minY
        self.vertices = vertices
    }

    init(width: CGFloat, height: CGFloat) {
        let topLeft     = CGPoint.zero.move(by: CGVector(dx: -width / 2, dy: -height / 2))
        let topRight    = CGPoint.zero.move(by: CGVector(dx: width / 2, dy: -height / 2))
        let bottomLeft  = CGPoint.zero.move(by: CGVector(dx: width / 2, dy: height / 2))
        let bottomRight = CGPoint.zero.move(by: CGVector(dx: -width / 2, dy: height / 2))
        self.width = width
        self.height = height
        self.vertices = [topLeft, topRight, bottomLeft, bottomRight]
    }
}
