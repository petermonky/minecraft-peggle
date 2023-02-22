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
            NavigationStack {
                NavigationLink(destination: LevelDesignerView()) {
                    Text("Level designer")
                }
                NavigationLink(destination: GamePlayerView(viewModel: GamePlayerViewModel(level: Level.mockData))) {
                    Text("Game player")
                }
            }
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.container)
//            let viewModel = GamePlayerViewModel(level: Level.mockData)
//            GamePlayerView(viewModel: viewModel)
                       // Level designer commented for PS3
//            LevelDesignerView()
//                .environment(\.colorScheme, .light)
//                .ignoresSafeArea(.container)
        }
    }
}
