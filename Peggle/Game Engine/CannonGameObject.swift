//
//  CannonGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/08.
//

import Foundation

final class CannonGameObject: GameObject {
    @Published private(set) var position: CGPoint
    @Published var angle: CGFloat

    init(position: CGPoint = CGPoint.zero, angle: CGFloat = CGFloat.zero) {
        self.position = position
        self.angle = angle
    }
}
