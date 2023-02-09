//
//  BoardGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct BoardGameView: View {
    @StateObject var renderer: Renderer

    init(renderer: Renderer) {
        _renderer = StateObject(wrappedValue: renderer)
    }

    var body: some View {
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
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    renderer.updateCannonAngle(position: value.location)
                }
                .onEnded { value in
                    renderer.fireBall(position: value.location)
                }
        )
        .frame(width: renderer.frame.width, height: renderer.frame.height)
        .background(
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
    }
}

struct BoardGameView_Previews: PreviewProvider {
    static var previews: some View {
        let gameEngine = GameEngine(level: Level.mockData)
        let renderer = Renderer(gameEngine: gameEngine)
        BoardGameView(renderer: renderer)
    }
}
