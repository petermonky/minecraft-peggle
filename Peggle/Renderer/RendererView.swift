//
//  BoardGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct RendererView: View {
    @StateObject private var renderer: Renderer

    init(renderer: Renderer) {
        _renderer = StateObject(wrappedValue: renderer)
    }

    var body: some View {
        GeometryReader { geometry in
            renderGameObjectViews()
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
            .onAppear {
                renderer.initialiseLevelObjects(frame: Frame(size: geometry.size))
            }
        }
        .ignoresSafeArea(edges: .all)
    }

    private func renderGameObjectViews() -> some View {
        ZStack {
            renderer.cannonGameView
            renderer.bucketGameView
            if let ballGameViews = renderer.ballGameViews {
                ForEach(ballGameViews) { $0 }
            }
            if let pegGameViews = renderer.pegGameViews {
                ForEach(pegGameViews) { $0 }
            }
            if let blockGameViews = renderer.blockGameViews {
                ForEach(blockGameViews) { $0 }
            }
            if let particleEffectViews = renderer.particleEffectViews {
                ForEach(particleEffectViews) { $0 }
            }
        }
    }
}

struct BoardGameView_Previews: PreviewProvider {
    static var previews: some View {
        let renderer = Renderer()
        _ = GameEngine(level: Level.mockData, renderer: renderer)
        return RendererView(renderer: renderer)
    }
}
