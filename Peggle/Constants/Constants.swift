//
//  File.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import Foundation

enum Constants {
}

extension Constants {
    enum PaletteButton {
        static let width: CGFloat = 100.0
        static let height: CGFloat = 100.0
        static let selectedOpacity = 0.5
    }
}

extension Constants {
    enum Peg {
        static let radius: CGFloat = 30.0
        static let afterImageOpacity = 0.5

        static let fadeDuration: CGFloat = 0.25
        static let popScale: CGFloat = 1.5
        static let blockingThreshold = 120
    }
}

extension Constants {
    enum Ball {
        static let radius: CGFloat = 30.0
        static let initialSpeed: CGFloat = 1_200
    }
}

extension Constants {
    enum Cannon {
        static let width: CGFloat = 120
        static let height: CGFloat = 120
    }
}

extension Constants {
    enum Physics {
        static let restitution: CGFloat = 0.85
        static let gravity = CGVector(dx: 0, dy: 980)
    }
}
