//
//  CannonGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/08.
//

import Foundation

final class CannonGameObject: ObservableObject {
    @Published private(set) var position: CGPoint
    @Published var angle: CGFloat
    @Published var isAvailable: Bool

    init(position: CGPoint = CGPoint.zero, angle: CGFloat = CGFloat.zero, isAvailable: Bool = true) {
        self.position = position
        self.angle = angle
        self.isAvailable = isAvailable
    }

    func setAvailable() {
        isAvailable = true
    }

    func setUnavailable() {
        isAvailable = false
    }
}
