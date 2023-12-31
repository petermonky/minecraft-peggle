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

    init(gameObject: PegGameObject) {
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
            .rotationEffect(.radians(gameObject.shape.rotation))
            .frame(width: 2 * gameObject.radius * scale,
                   height: 2 * gameObject.radius * scale)
            .position(gameObject.position)
            .opacity(opacity)
            .onChange(of: gameObject.isVisible) { isVisible in
                withAnimation(.easeOut(duration: Constants.Peg.fadeDuration)) {
                    if !isVisible {
                        opacity = 0
                        scale = Constants.Peg.popScale
                    }
                }
            }
    }
}

struct PegGameView_Previews: PreviewProvider {
    static var previews: some View {
        let pegGameObject = PegGameObject()
        PegGameView(gameObject: pegGameObject)
    }
}
