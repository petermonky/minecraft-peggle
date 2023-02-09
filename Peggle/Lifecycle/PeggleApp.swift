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
            let gameEngine = GameEngine(level: Level.mockData)
            let renderer = Renderer(gameEngine: gameEngine)
            BoardGameView(renderer: renderer)
                .environment(\.colorScheme, .light)
                .ignoresSafeArea(.container)
            // Level designer commented for PS3
//            LevelDesignerView()
//                .environment(\.colorScheme, .light)
//                .ignoresSafeArea(.container)
        }
    }
}
