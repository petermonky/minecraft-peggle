//
//  Frame.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

struct Frame: FrameCollidable {
    var width: CGFloat
    var height: CGFloat

    init(width: CGFloat = CGFloat.zero, height: CGFloat = CGFloat.zero) {
        self.width = width
        self.height = height
    }
}
