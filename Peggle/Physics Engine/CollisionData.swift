//
//  CollisionData.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/09.
//

import Foundation

protocol CollisionData: Hashable {
    var sourceId: String { get }
}
