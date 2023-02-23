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
        static let width: CGFloat = 120.0
        static let height: CGFloat = 120.0
        static let selectedOpacity = 0.5
    }
}

extension Constants {
    enum LevelObject {
        static let afterImageOpacity = 0.5
    }
}

extension Constants {
    enum Peg {
        static let radius: CGFloat = 30.0

        static let fadeDuration: CGFloat = 0.25
        static let popScale: CGFloat = 1.5
        static let blockingThreshold = 120
    }
}

extension Constants {
    enum Block {
        static let width: CGFloat = 60.0
        static let height: CGFloat = 60.0
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
        static let width: CGFloat = 100.0
        static let height: CGFloat = 100.0
        static let overlayDuration: CGFloat = 0.15
        static let overlayOpacity: CGFloat = 0.5
    }
}

extension Constants {
    enum Bucket {
        static let width: CGFloat = 100.0
        static let height: CGFloat = 100.0
    }
}

extension Constants {
    enum Physics {
        static let restitution: CGFloat = 0.85
        static let gravity = CGVector(dx: 0, dy: 980)
    }
}
