//
//  CGPoint+Utility.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/04.
//

import Foundation

extension CGPoint {
    func move(by vector: CGVector) -> CGPoint {
        let x = self.x + vector.dx
        let y = self.y + vector.dy

        return CGPoint(x: x, y: y)
    }
}
