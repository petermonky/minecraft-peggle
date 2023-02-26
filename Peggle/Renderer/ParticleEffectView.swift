//
//  ParticleEffectView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/26.
//

import Foundation
import SwiftUI

struct ParticleEffectView: View, Identifiable {
    @StateObject var gameObject: ParticleEffectGameObject
    @State var angle: CGFloat
    @State var scale: Double
    @State var opacity: Double
    let id: String

    init(gameObject: ParticleEffectGameObject) {
        _gameObject = StateObject(wrappedValue: gameObject)
        angle = 0
        scale = 1
        opacity = 1
        id = gameObject.id
    }

    var body: some View {
        Image(gameObject.imageName)
            .resizable()
            .scaledToFit()
            .rotationEffect(.radians(angle))
            .frame(width: 400 * scale, height: 400 * scale) // TODO: change to particle size
            .position(gameObject.position)
            .opacity(opacity)
            .onChange(of: gameObject.isVisible) { isVisible in
                withAnimation(.easeOut(duration: gameObject.duration)) {
                    if !isVisible {
                        opacity = 0
                        scale = 1.25 // TODO: change
                        angle = gameObject.angle
                    }
                }
            }
            .onAppear {
                gameObject.fadeAway()
            }
    }
}

struct ParticleEffectView_Previews: PreviewProvider {
    static var previews: some View {
        let gameObject = ParticleEffectGameObject(imageName: "explosion")
        ParticleEffectView(gameObject: gameObject)
    }
}
