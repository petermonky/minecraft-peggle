//
//  Cloneable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import Foundation

protocol Cloneable {
    init(instance: Self)
}

extension Cloneable {
    func clone() -> Self {
        Self(instance: self)
    }
}
