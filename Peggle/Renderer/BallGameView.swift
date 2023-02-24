//
//  BallGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import SwiftUI

struct BallGameView: View, Identifiable {
    @StateObject var gameObject: BallGameObject
    let id: String

    init(gameObject: BallGameObject) {
        _gameObject = StateObject(wrappedValue: gameObject)
        id = gameObject.id
    }

    var body: some View {
        Image(gameObject.isSpooky ? "peg-red-glow" : "ball") // TODO: spooky
            .resizable()
            .frame(width: 2 * Constants.Ball.radius,
                   height: 2 * Constants.Ball.radius)
            .clipShape(Circle())
            .position(gameObject.position)
    }
}

struct BallGameView_Previews: PreviewProvider {
    static var previews: some View {
        let ballGameObject = BallGameObject(velocity: CGVector.zero)
        BallGameView(gameObject: ballGameObject)
    }
}
