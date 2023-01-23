//
//  CGPoint+Hashable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
