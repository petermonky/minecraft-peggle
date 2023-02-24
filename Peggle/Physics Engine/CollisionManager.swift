//
//  CollisionManager.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

class CollisionManager {
}

extension CollisionManager {
    static func hasCollisionBetween(_ first: any Collidable, and second: any Collidable) -> Bool {
        if let first = first as? any CircleCollidable {
            if let second = second as? any CircleCollidable {
                return hasCollisionBetween(circle1: first, circle2: second)
            } else if let second = second as? any PolygonCollidable {
                return hasCollisionBetween(circle: first, polygon: second)
            } else if let second = second as? any FrameCollidable {
                return hasCollisionBetween(circle: first, frame: second)
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
                continue
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

    private static func hasCollisionBetween(circle: any CircleCollidable, frame: any FrameCollidable) -> Bool {
        let hasLeftCollision = circle.position.x - circle.radius < 0
        let hasRightCollision = circle.position.x + circle.radius > frame.width
        let hasTopCollision = circle.position.y - circle.radius < 0
        let hasBottomCollision = circle.position.y + circle.radius > frame.height

        return hasLeftCollision || hasRightCollision || hasTopCollision || hasBottomCollision
    }
}

extension CollisionManager {
    static func resolveCollisionBetween(
        _ first: any DynamicPhysicsBody,
        and second: any PhysicsBody,
        restitution: CGFloat = Constants.Physics.restitution
    ) -> (any CollisionData)? {
        if let first = first as? any DynamicCirclePhysicsBody {
            if let second = second as? any CirclePhysicsBody {
                return resolveCollisionBetween(circle1: first, circle2: second)
            } else if let second = second as? any PolygonPhysicsBody {
                return resolveCollisionBetween(circle: first, polygon: second)
            }
        }
        return nil
    }

    private static func resolveCollisionBetween(
        circle1: any DynamicCirclePhysicsBody,
        circle2: any CirclePhysicsBody,
        restitution: CGFloat = Constants.Physics.restitution
    ) -> BodyBodyCollisionData {
        let normalised = CGVector(from: circle2.position, to: circle1.position).normalise
        let scaled = normalised.scale(by: circle1.shape.radius + circle2.shape.radius)

        circle1.position = circle2.position.move(by: scaled)
        circle1.velocity = circle1.velocity.reflectAlongVector(normalised).scale(by: restitution)
        return BodyBodyCollisionData(body1: circle1, body2: circle2)
    }

    private static func resolveCollisionBetween(
        circle: any DynamicCirclePhysicsBody,
        polygon: any PolygonPhysicsBody,
        restitution: CGFloat = Constants.Physics.restitution
    ) -> BodyBodyCollisionData? {
        guard let closestSegment = closestSegmentFrom(circle, to: polygon) else {
            return nil
        }
        let closestPoint = closestSegment.closestPoint(to: circle.position)
        let normalised = CGVector(from: closestPoint, to: circle.position).normalise
        let scaled = normalised.scale(by: circle.radius)

        circle.position = closestPoint.move(by: scaled)
        circle.velocity = circle.velocity.reflectAlongVector(normalised).scale(by: restitution)
        return BodyBodyCollisionData(body1: circle, body2: polygon)
    }

    private static func closestSegmentFrom(
        _ body: any DynamicPhysicsBody,
        to polygon: any PolygonPhysicsBody
    ) -> Segment? {
        var minDistance = CGFloat.infinity
        var minSegment: Segment?
        for segment in polygon.segments where segment.distance(to: body.position) < minDistance {
            minDistance = segment.distance(to: body.position)
            minSegment = segment
        }
        return minSegment
    }

    static func resolveCollisionBetween(
        body: any DynamicPhysicsBody,
        frame: any FrameCollidable,
        restitution: CGFloat = Constants.Physics.restitution
    ) -> BodyFrameCollisionData? {
        guard let closestSide = closestSideFrom(body, to: frame) else {
            return nil
        }

        switch closestSide {
        case .left:
            body.velocity = body.velocity.reflectAlongXAxis().scale(by: restitution)
        case .right:
            body.velocity = body.velocity.reflectAlongXAxis().scale(by: restitution)
        case .top:
            body.velocity = body.velocity.reflectAlongYAxis().scale(by: restitution)
        case .bottom:
            body.velocity = body.velocity.reflectAlongYAxis().scale(by: restitution)
        }

        let collisionData = BodyFrameCollisionData(body: body, side: closestSide)
        return collisionData
    }

    private static func closestSideFrom(_ body: any DynamicPhysicsBody, to frame: any FrameCollidable) -> FrameSide? {
        var distance = CGFloat.infinity
        var closestSide: FrameSide?

        if body.position.x < distance {
            closestSide = .left
            distance = body.position.x
        }
        if frame.width - body.position.x < distance {
            closestSide = .right
            distance = frame.width - body.position.x
        }
        if body.position.y < distance {
            closestSide = .top
            distance = body.position.y
        }
        if frame.height - body.position.y < distance {
            closestSide = .bottom
            distance = frame.height - body.position.y
        }

        return closestSide
    }
}
