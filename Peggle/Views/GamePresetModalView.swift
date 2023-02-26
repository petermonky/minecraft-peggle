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
            VStack(alignment: .leading, spacing: 16) {
                Text("Character").font(.custom("Minecraft-Regular", size: 32)).padding(.bottom, 4)
                ForEach(gameEngine.selectableCharacters, id: \.name) { character in
                    Button(action: {
                        gameEngine.setCharacter(character)
                    }) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(character.name).font(.custom("Minecraft-Bold", size: 20))
                            Text(character.description).font(.custom("Minecraft-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GrayButton())
                    .disabled(gameEngine.character === character)
                }
            }
            VStack(alignment: .leading, spacing: 16) {
                Text("Game Mode").font(.custom("Minecraft-Regular", size: 32)).padding(.bottom, 4)
                ForEach(gameEngine.selectableGameModes, id: \.name) { mode in
                    Button(action: {
                        gameEngine.setGameMode(mode)
                    }) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(mode.name).font(.custom("Minecraft-Bold", size: 20))
                            Text(mode.description).font(.custom("Minecraft-Regular", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GrayButton())
                    .disabled(gameEngine.mode === mode)
                }
            }
            Button(action: {
                gameEngine.startGame()
            }) {
                Text("Start").font(.custom("Minecraft-Regular", size: 20))
            }.disabled(!gameEngine.isPresetSelected)
        }
        .frame(width: 600)
        .padding(32)
        .background(
            Image("background-dirt")
                .resizable(resizingMode: .tile)
        )
        .cornerRadius(8)
    }
}

struct CharacterModalView_Previews: PreviewProvider {
    static var previews: some View {
        let renderer = Renderer()
        let gameEngine = GameEngine(level: Level.mockData, renderer: renderer)
        GamePresetModalView().environmentObject(gameEngine)
    }
}
