//
//  CGPoint+Distance.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}
