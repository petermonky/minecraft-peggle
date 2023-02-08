//
//  BallGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import SwiftUI

struct BallGameView: GameView {
    let id: UUID
    let gameObject: BallGameObject

    init(gameObject: BallGameObject = .init()) {
        self.id = UUID()
        self.gameObject = gameObject
    }

    var body: some View {
        Image("ball")
            .resizable()
            .frame(width: 2 * Constants.Ball.radius,
                   height: 2 * Constants.Ball.radius)
            .clipShape(Circle())
            .position(gameObject.position)
    }
}

struct BallGameView_Previews: PreviewProvider {
    static var previews: some View {
        BallGameView()
    }
}
