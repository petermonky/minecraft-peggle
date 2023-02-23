//
//  CollisionManager.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

class CollisionManager {
    static func hasCollisionBetween(_ first: any Collidable, _ second: any Collidable) -> Bool {
        if let first = first as? any CircleCollidable {
            if let second = second as? any CircleCollidable {
                return hasCollisionBetween(circle1: first, circle2: second)
            } else if let second = second as? any PolygonCollidable {
                return hasCollisionBetween(circle: first, polygon: second)
            }
        } else if let first = first as? any PolygonCollidable {
            if let second = second as? any CircleCollidable {
                return hasCollisionBetween(circle: second, polygon: first)
            } else if let second = second as? any PolygonCollidable {
                return hasCollisionBetween(polygon1: first, polygon2: second)
            }
        }
        return false
    }

    private static func hasCollisionBetween(circle1: any CircleCollidable, circle2: any CircleCollidable) -> Bool {
        circle1.position.distance(to: circle2.position) <= (circle1.shape.radius + circle2.shape.radius)
    }

    private static func hasCollisionBetween(circle: any CircleCollidable, polygon: any PolygonCollidable) -> Bool {
        let segments = polygon.segments
        for segment in segments {
            if circle.contains(segment.start) || circle.contains(segment.end) {
                return true
            }
            let projection = circle.position.project(onto: segment)
            if !circle.contains(projection) {
                return false
            }
            let startToProjectionLength = CGVector(from: segment.start, to: projection).length
            let endToProjectionLength = CGVector(from: segment.end, to: projection).length
            let segmentLength = CGVector(from: segment.start, to: segment.end).length
            if startToProjectionLength + endToProjectionLength <= segmentLength {
                return true
            }
        }
        return polygon.contains(circle.position)
    }

    private static func hasCollisionBetween(polygon1: any PolygonCollidable, polygon2: any PolygonCollidable) -> Bool {
        let vertices1 = polygon1.vertices
        let vertices2 = polygon2.vertices
        for vertex in vertices1 where polygon2.contains(vertex) {
            return true
        }
        for vertex in vertices2 where polygon1.contains(vertex) {
            return true
        }
        return false
    }
}
