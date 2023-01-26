//
//  PeggleApp.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/18.
//

import SwiftUI

@main
struct PeggleApp: App {
    var body: some Scene {
        WindowGroup {
            LevelDesignerView()
                .environment(\.colorScheme, .light)
        }
    }
}
