//
//  PegGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import SwiftUI

struct PegGameView: View, Identifiable {
    @StateObject var gameObject: PegGameObject
    @State var scale: Double
    @State var opacity: Double
    let id: String

    init(gameObject: PegGameObject = .init()) {
        _gameObject = StateObject(wrappedValue: gameObject)
        scale = 1
        opacity = 1
        id = gameObject.id
    }

    var body: some View {
        Image(gameObject.hasCollidedWithBall
              ? gameObject.peg.glowImageName
              : gameObject.peg.normalImageName)
            .resizable()
            .scaledToFill()
            .frame(width: 2 * Constants.Peg.radius * scale,
                   height: 2 * Constants.Peg.radius * scale)
            .position(gameObject.position)
            .opacity(opacity)
            .onChange(of: gameObject.isVisible) { _ in
                withAnimation(.easeOut(duration: Constants.Peg.fadeDuration)) {
                    opacity = 0
                    scale = Constants.Peg.popScale
                }
            }
    }
}

struct PegGameView_Previews: PreviewProvider {
    static var previews: some View {
        PegGameView()
    }
}
