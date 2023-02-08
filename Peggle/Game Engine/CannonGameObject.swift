//
//  CannonGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/08.
//

import Foundation

final class CannonGameObject {
    let position: CGPoint
    var angle: CGFloat

    init(position: CGPoint = CGPoint.zero, angle: CGFloat = CGFloat.zero) {
        self.position = position
        self.angle = angle
    }
}
