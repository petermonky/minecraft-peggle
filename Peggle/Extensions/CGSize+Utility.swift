//
//  CGSize+Utility.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/09.
//

import Foundation

extension CGSize {
    func extend(x: CGFloat = 0, y: CGFloat = 0) -> CGSize {
        let width = width + x
        let height = height + y
        return CGSize(width: width, height: height)
    }
}
