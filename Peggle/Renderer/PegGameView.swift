//
//  PegGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import SwiftUI

struct PegGameView: GameView {
    let id: UUID
    let gameObject: PegGameObject

    init(gameObject: PegGameObject = .init()) {
        self.id = UUID()
        self.gameObject = gameObject
    }

    var body: some View {
        Image(gameObject.hasCollidedWithBall
              ? gameObject.peg.glowImageName
              : gameObject.peg.normalImageName)
            .resizable()
            .frame(width: 2 * Constants.Peg.radius,
                   height: 2 * Constants.Peg.radius)
            .clipShape(Circle())
            .position(gameObject.position)
    }
}

struct PegGameView_Previews: PreviewProvider {
    static var previews: some View {
        PegGameView()
    }
}
