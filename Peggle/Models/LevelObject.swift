//
//  LevelObject.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation
import SwiftUI

protocol LevelObject: Identifiable, Codable {
    var id: UUID { get }
    var position: CGPoint { get set }
}
