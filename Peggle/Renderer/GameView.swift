//
//  GameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/09.
//

import Foundation
import SwiftUI

protocol GameView: View {
    associatedtype Object: GameObject

    var gameObject: Object { get set }
}
