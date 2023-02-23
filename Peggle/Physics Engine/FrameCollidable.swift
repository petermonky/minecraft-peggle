//
//  FrameCollidable.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

protocol FrameCollidable: Collidable {
    var width: CGFloat { get }
    var height: CGFloat { get }
}
