//
//  CannonGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct CannonGameView: View {
    @StateObject var gameObject: CannonGameObject

    init(gameObject: CannonGameObject = .init()) {
        _gameObject = StateObject(wrappedValue: gameObject)
    }

    var body: some View {
        SpriteView(
            spriteSheet: Image("cannon"),
            width: Constants.Cannon.width,
            height: Constants.Cannon.height,
            frame: 1
        )
            .rotationEffect(.radians(gameObject.angle))
            .position(gameObject.position)
            .zIndex(Double.infinity)
    }
}

struct CannonGameView_Previews: PreviewProvider {
    static var previews: some View {
        CannonGameView()
    }
}
