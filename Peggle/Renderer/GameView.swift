//
//  GameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import Foundation
import SwiftUI

protocol GameView: View, Identifiable {
    var id: UUID { get }
}
