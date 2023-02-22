//
//  BucketGameObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation

final class BucketGameObject: GameObject {
    @Published private(set) var position: CGPoint

    init(position: CGPoint = CGPoint.zero) {
        self.position = position
    }
}
