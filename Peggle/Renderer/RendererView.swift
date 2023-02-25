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
            ZStack {
                renderer.cannonGameView
                if let ballGameViews = renderer.ballGameViews {
                    ForEach(ballGameViews) { $0 }
                }
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
                Image("background-ores")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
        .ignoresSafeArea(edges: .all)
    }
}

struct BoardGameView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        RendererView(gameEngine: gameEngine)
    }
}
