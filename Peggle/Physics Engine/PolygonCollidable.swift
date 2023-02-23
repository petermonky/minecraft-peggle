//
//  PolygonCollidable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

protocol PolygonCollidable: Collidable where Shape == PolygonPhysicsShape {
    override var shape: PolygonPhysicsShape { get }

    var vertices: [CGPoint] { get }
    var segments: [Segment] { get }
}

extension PolygonCollidable {
    var vertices: [CGPoint] {
        shape.vertices.map { position.move(by: CGVector(dx: $0.x, dy: $0.y)) }
    }

    var segments: [Segment] {
        var segments: [Segment] = []
        for i in 0..<vertices.count {
            let start = vertices[i]
            let end = vertices[(i + 1) % vertices.count]
            let segment = Segment(start: start, end: end)
            segments.append(segment)
        }
        return segments
    }

    func contains(_ point: CGPoint) -> Bool {
        let positionToPoint = Segment(start: position, end: point)
        for segment in segments {
            if segment.intersects(with: positionToPoint) {
                return false
            }
        }
        return true
    }
}
