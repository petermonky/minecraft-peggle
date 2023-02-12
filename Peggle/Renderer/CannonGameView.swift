//
//  CannonGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct CannonGameView: View {
    @StateObject var gameObject: CannonGameObject
    @State var overlayOpacity: CGFloat

    init(gameObject: CannonGameObject) {
        _gameObject = StateObject(wrappedValue: gameObject)
        overlayOpacity = 0
    }

    var body: some View {
        ZStack {
            SpriteView(
                spriteSheet: Image("cannon"),
                width: Constants.Cannon.width,
                height: Constants.Cannon.height,
                frame: 1
            )

            SpriteView(
                spriteSheet: Image("cannon")
                    .renderingMode(.template),
                width: Constants.Cannon.width,
                height: Constants.Cannon.height,
                frame: 1
            )
            .foregroundColor(.white)
            .opacity(overlayOpacity)
        }
        .rotationEffect(.radians(gameObject.angle))
        .position(gameObject.position)
        .zIndex(Double.infinity)
        .onChange(of: gameObject.isAvailable) { isAvailable in
            withAnimation(.easeOut(duration: Constants.Cannon.overlayDuration)) {
                overlayOpacity = isAvailable ? 0 : Constants.Cannon.overlayOpacity
            }
        }
    }
}

struct CannonGameView_Previews: PreviewProvider {
    static var previews: some View {
        let cannonGameObject = CannonGameObject()
        CannonGameView(gameObject: cannonGameObject)
    }
}
