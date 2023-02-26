//
//  Frame.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

struct Frame: Codable, Equatable, FrameCollidable {
    var width: CGFloat
    var height: CGFloat

    init(width: CGFloat = CGFloat.zero, height: CGFloat = CGFloat.zero) {
        self.width = width
        self.height = height
    }

    init(size: CGSize = CGSize.zero) {
        self.width = size.width
        self.height = size.height
    }

    func adjust(x: CGFloat = 0, y: CGFloat = 0) -> Frame {
        let width = width + x
        let height = height + y
        return Frame(width: width, height: height)
    }
}
