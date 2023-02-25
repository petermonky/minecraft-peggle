//
//  GameOverModalView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct GameOverModalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameEngine: GameEngine

    var body: some View {
        VStack(spacing: 32) {
            Text(gameEngine.isInState(.win) ? "YOU WIN" : "GAME OVER")
                .font(.custom("Minecraft-Bold", size: 32))

            Button(action: {
                dismiss()
            }) {
                Text("Return")
                    .font(.custom("Minecraft-Regular", size: 20))
            }
        }
        .padding(32)
        .background(
            Image("background-dirt")
                .resizable(resizingMode: .tile)
        )
        .cornerRadius(8)
    }
}

struct GameOverModalView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        let renderer = Renderer(gameEngine: gameEngine)
        GameOverModalView().environmentObject(renderer)
    }
}
