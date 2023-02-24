//
//  BoardGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct RendererView: View {
    private var gameEngine: GameEngine
    @StateObject private var renderer: Renderer

    init(gameEngine: GameEngine) {
        self.gameEngine = gameEngine
        _renderer = StateObject(wrappedValue: Renderer(gameEngine: gameEngine))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(renderer.remainingTime ?? 1)")
                Text("\(renderer.remainingLives ?? 1)")
            }.frame(height: 80)
            GeometryReader { _ in
                ZStack {
                    renderer.cannonGameView
                    renderer.ballGameView
                    renderer.bucketGameView
                    if let pegGameViews = renderer.pegGameViews {
                        ForEach(pegGameViews) { $0 }
                    }
                    if let blockGameViews = renderer.blockGameViews {
                        ForEach(blockGameViews) { $0 }
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            gameEngine.updateCannonAngle(position: value.location)
                        }
                        .onEnded { value in
                            gameEngine.addBallTowards(position: value.location)
                        }
                )
                .frame(width: renderer.frame.width, height: renderer.frame.height)
                .background(
                    Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .onAppear {
                    // TODO: resize gameboard view
                }
            }
        }
        .modifier(Popup(isPresented: gameEngine.isInState(.loading),
                        alignment: .center,
                        content: { CharacterModalView(gameEngine: gameEngine) }))
        .modifier(Popup(isPresented: gameEngine.isInState(.lose),
                        alignment: .center,
                        content: { GameOverModalView(gameEngine: gameEngine) }))
        .ignoresSafeArea(edges: .all)
    }
}

struct BoardGameView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        RendererView(gameEngine: gameEngine)
    }
}
