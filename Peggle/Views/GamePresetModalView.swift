//
//  MasterModalView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct GamePresetModalView: View {
    @EnvironmentObject var gameEngine: GameEngine

    var body: some View {
        VStack(spacing: 24) {
            renderCharacterSection()
            renderGameModeSection()
            renderStartButton()
        }
        .frame(width: 600)
        .padding(32)
        .background(
            Image("background-dirt")
                .resizable(resizingMode: .tile)
        )
        .cornerRadius(8)
    }

    private func renderCharacterSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Character").font(.custom("Minecraft-Regular", size: 32)).padding(.bottom, 4)
            ForEach(gameEngine.selectableCharacters, id: \.name) { character in
                Button(action: {
                    gameEngine.setCharacter(character)
                }) {
                    renderButtonContent(title: character.name, description: character.description)
                }
                .buttonStyle(GrayButton())
                .disabled(gameEngine.character === character)
            }
        }
    }

    private func renderGameModeSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Game Mode").font(.custom("Minecraft-Regular", size: 32)).padding(.bottom, 4)
            ForEach(gameEngine.selectableGameModes, id: \.name) { mode in
                Button(action: {
                    gameEngine.setGameMode(mode)
                }) {
                    renderButtonContent(title: mode.name, description: mode.description)
                }
                .buttonStyle(GrayButton())
                .disabled(gameEngine.mode === mode)
            }
        }
    }

    private func renderButtonContent(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title).font(.custom("Minecraft-Bold", size: 20))
            Text(description).font(.custom("Minecraft-Regular", size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }

    private func renderStartButton() -> some View {
        Button(action: {
            gameEngine.startGame()
        }) {
            Text("Start").font(.custom("Minecraft-Regular", size: 20))
        }
        .disabled(!gameEngine.isPresetSelected)
    }
}

struct CharacterModalView_Previews: PreviewProvider {
    static var previews: some View {
        let renderer = Renderer()
        let gameEngine = GameEngine(level: Level.PeggleShowdown, renderer: renderer)
        GamePresetModalView().environmentObject(gameEngine)
    }
}
