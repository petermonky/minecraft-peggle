//
//  BoardGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct RendererView: View {
    @StateObject var renderer: Renderer

    init(renderer: Renderer) {
        _renderer = StateObject(wrappedValue: renderer)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Header")
            }.frame(height: 80)
            GeometryReader { _ in
                ZStack {
                    if let cannonGameView = renderer.cannonGameView {
                        cannonGameView
                    }
                    if let ballGameView = renderer.ballGameView {
                        ballGameView
                    }
                    if let pegGameViews = renderer.pegGameViews {
                        ForEach(pegGameViews) { $0 }
                    }
                    if let blockGameViews = renderer.blockGameViews {
                        ForEach(blockGameViews) { $0 }
                    }
                    if let bucketGameView = renderer.bucketGameView {
                        bucketGameView
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
        .ignoresSafeArea(edges: .all)
    }
}

struct BoardGameView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        let renderer = Renderer(gameEngine: gameEngine)
        RendererView(renderer: renderer)
    }
}
