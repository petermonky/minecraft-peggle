//
//  DisplayLink.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation
import SwiftUI

class DisplayLink: NSObject, ObservableObject {
    @Published var frameDuration: CFTimeInterval = 0
    @Published var frameChange = false

    static let shared = DisplayLink()
}
