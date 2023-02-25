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
                GeometryReader { _ in
                    VStack(spacing: 20) {
                        NavigationLink(destination: NavigationLazyView(LevelSelectionView(viewModel: LevelSelectionViewModel()))) {
                            Text("Choose Level")
                        }
                        .buttonStyle(GrayButton(minWidth: 400, minHeight: 80))
                        NavigationLink(destination: NavigationLazyView(LevelDesignerView(viewModel: LevelDesignerViewModel()))) {
                            Text("Level Designer")
                        }
                        .buttonStyle(GrayButton(minWidth: 400, minHeight: 80))
                    }
                    .font(.custom("Minecraft-Regular", size: 32))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(
                    Image("background-dirt")
                        .resizable(resizingMode: .tile)
                )
                .ignoresSafeArea(.container)
            }
        }
    }
}
