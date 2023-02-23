//
//  CGPoint+Utility.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }

    func move(by vector: CGVector) -> CGPoint {
        let x = self.x + vector.dx
        let y = self.y + vector.dy

        return CGPoint(x: x, y: y)
    }

    func project(onto segment: Segment) -> CGPoint {
        let startToEnd = CGVector(from: segment.start, to: segment.end)
        let startToSelf = CGVector(from: segment.start, to: self)
        return segment.start.move(by: startToSelf.project(onto: startToEnd))
    }
}
