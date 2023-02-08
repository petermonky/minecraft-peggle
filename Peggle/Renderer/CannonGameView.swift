//
//  CannonGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/07.
//

import SwiftUI

struct CannonGameView: GameView {
    let id: UUID
    let gameObject: CannonGameObject

    init(gameObject: CannonGameObject = .init()) {
        self.id = UUID()
        self.gameObject = gameObject
    }

    var body: some View {
        SpriteView(spriteSheet: Image("cannon"), width: 120, height: 120, frame: 1)
            .rotationEffect(.radians(gameObject.angle))
            .position(gameObject.position)
    }
}

struct CannonGameView_Previews: PreviewProvider {
    static var previews: some View {
        CannonGameView()
    }
}
