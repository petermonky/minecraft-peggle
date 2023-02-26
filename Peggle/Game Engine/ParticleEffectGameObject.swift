//
//  ParticleEffectGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/26.
//

import Foundation

final class ParticleEffectGameObject: ObservableObject {
    let position: CGPoint
    let imageName: String
    let duration: CGFloat
    let angle: CGFloat
    @Published var isVisible: Bool

    init(
        position: CGPoint = .zero,
        imageName: String = "",
        duration: CGFloat = .zero,
        angle: CGFloat = .zero
    ) {
        self.position = position
        self.imageName = imageName
        self.isVisible = true
        self.duration = duration
        self.angle = angle
    }

    func fadeAway() {
        isVisible = false
    }
}

extension ParticleEffectGameObject {
    var id: String {
        String(UInt(bitPattern: ObjectIdentifier(self)))
    }
}
