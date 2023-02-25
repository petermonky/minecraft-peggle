//
//  PolygonPhysicsShape.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

struct PolygonPhysicsShape: PhysicsShape {
    var vertices: [CGPoint]

    var width: CGFloat {
        var minX = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude

        for vertex in vertices {
            if vertex.x < minX {
                minX = vertex.x
            }
            if vertex.x > maxX {
                maxX = vertex.x
            }
        }

        return maxX - minX
    }

    var height: CGFloat {
        var minY = CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude

        for vertex in vertices {
            if vertex.y < minY {
                minY = vertex.y
            }
            if vertex.y > maxY {
                maxY = vertex.y
            }
        }

        return maxY - minY
    }

    init(vertices: [CGPoint] = [
        CGPoint(x: -1, y: -1),
        CGPoint(x: -1, y: 1),
        CGPoint(x: 1, y: -1),
        CGPoint(x: 1, y: 1)
    ]) {
        self.vertices = vertices
    }

    init(width: CGFloat, height: CGFloat) {
        let topLeft     = CGPoint.zero.move(by: CGVector(dx: -width / 2, dy: -height / 2))
        let topRight    = CGPoint.zero.move(by: CGVector(dx: width / 2, dy: -height / 2))
        let bottomLeft  = CGPoint.zero.move(by: CGVector(dx: width / 2, dy: height / 2))
        let bottomRight = CGPoint.zero.move(by: CGVector(dx: -width / 2, dy: height / 2))
        self.vertices = [topLeft, topRight, bottomLeft, bottomRight]
    }

    mutating func scale(by value: CGFloat) {
        for i in vertices.indices {
            let vertex = vertices[i]
            let centerToVertex = CGVector(from: center, to: vertex)
            let scaled = centerToVertex.scale(by: value)
            vertices[i] = CGPoint(x: scaled.dx, y: scaled.dy)
        }
    }
}
