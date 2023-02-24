//
//  MasterModalView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct GamePresetModalView: View {
    @EnvironmentObject var renderer: Renderer
    @State var character: GameCharacter?
    @State var mode: GameMode?

    var isPresetSelected: Bool {
        character != nil && mode != nil
    }

    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                character = KaboomCharacter()
            }) {
                Text("Kaboom")
            }
            Button(action: {
                character = SpookyCharacter()
            }) {
                Text("Spooky")
            }
            Button(action: {
                mode = NormalMode()
            }) {
                Text("Normal")
            }
            Button(action: {
                mode = BeatTheScoreMode()
            }) {
                Text("Beat the score")
            }
            Button(action: {
                mode = SiamLeftSiamRightMode()
            }) {
                Text("Siam left Siam right")
            }
            Button(action: {
                guard let character = character,
                      let mode = mode else {
                    return
                }
                renderer.startGameEngine(character: character, mode: mode)
            }) {
                Text("Start")
            }.disabled(!isPresetSelected)
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
    }
}

struct CharacterModalView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        let renderer = Renderer(gameEngine: gameEngine)
        GamePresetModalView().environmentObject(renderer)
    }
}
