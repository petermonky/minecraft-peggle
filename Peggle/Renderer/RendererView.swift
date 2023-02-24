//
//  BoardGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct RendererView: View {
    @StateObject private var renderer: Renderer

    init(gameEngine: GameEngine) {
        _renderer = StateObject(wrappedValue: Renderer(gameEngine: gameEngine))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(renderer.remainingTime ?? 0)")
                Text("\(renderer.remainingLives ?? 0)")
                Text("\(renderer.score)")
                Text("\(renderer.bluePegsCount)")
                Text("\(renderer.orangePegsCount)")
                Text("\(renderer.greenPegsCount)")
                Text("\(renderer.goalText)")
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
                            renderer.updateCannonAngle(position: value.location)
                        }
                        .onEnded { value in
                            renderer.addBallTowards(position: value.location)
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
        .modifier(Popup(isPresented: renderer.isGameInState(.loading),
                        alignment: .center,
                        content: { GamePresetModalView().environmentObject(renderer) }))
        .modifier(Popup(isPresented: renderer.isGameOver,
                        alignment: .center,
                        content: { GameOverModalView().environmentObject(renderer) }))
        .ignoresSafeArea(edges: .all)
    }
}

struct BoardGameView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        RendererView(gameEngine: gameEngine)
    }
}
