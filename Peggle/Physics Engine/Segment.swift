//
//  Segment.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

enum Orientation {
    case clockwise
    case counterclockwise
    case colinear
}

struct Segment {
    var start: CGPoint
    var end: CGPoint
}

extension Segment {
    // adapted from https://stackoverflow.com/a/6853926
    func closestPoint(to point: CGPoint) -> CGPoint {
        let a = point.x - start.x
        let b = point.y - start.y
        let c = end.x - start.x
        let d = end.y - start.y

        let dot = a * c + b * d
        let len_sq = c * c + d * d
        let param = dot / len_sq

        var xx, yy: CGFloat

        if param < 0 || (start.x == end.x && start.y == end.y) {
            xx = start.x
            yy = end.y
        } else if param > 1 {
            xx = end.x
            yy = end.y
        } else {
            xx = start.x + param * c
            yy = start.y + param * d
        }

        return CGPoint(x: xx, y: yy)
    }

    func distance(to point: CGPoint) -> CGFloat {
        let closestPoint = closestPoint(to: point)

        let dx = point.x - closestPoint.x
        let dy = point.y - closestPoint.y

        return sqrt(dx * dx + dy * dy)
    }

    func contains(_ point: CGPoint) -> Bool {
        guard orientation(with: point) == .colinear else {
            return false
        }
        if point.x <= max(start.x, end.x) && point.x >= min(start.x, end.x)
            && point.y <= max(start.y, end.y) && point.y >= min(start.y, end.y) {
            return true
        }
        return false
    }

    func orientation(with point: CGPoint) -> Orientation {
        let value = (end.y - start.y) * (point.x - end.x)
                    - (end.x - start.x) * (point.y - end.y)

        if value < 0 {
            return .counterclockwise
        } else if value > 0 {
            return .clockwise
        } else {
            return .colinear
        }
    }

    func intersects(with segment: Segment) -> Bool {
        let o1 = orientation(with: segment.start)
        let o2 = orientation(with: segment.end)
        let o3 = segment.orientation(with: start)
        let o4 = segment.orientation(with: end)

        if o1 != o2 && o3 != o4 {
            return true
        }
        if contains(segment.start)
            || contains(segment.end)
            || segment.contains(start)
            || segment.contains(end) {
            return true
        }
        return false
    }
}
