//
//  GameOverModalView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct GameOverModalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var renderer: Renderer

    var body: some View {
        VStack(spacing: 16) {
            Text(renderer.isGameInState(.win) ? "YOU WIN" : "GAME OVER")
            HStack(spacing: 16) {
                Button(action: {
                    print("replay")
                }) {
                    Text("Replay")
                }
                Button(action: {
                    print("menu")
                    dismiss()
                }) {
                    Text("Main menu")
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
    }
}

struct GameOverModalView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        let renderer = Renderer(gameEngine: gameEngine)
        GameOverModalView().environmentObject(renderer)
    }
}
