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

    init(gameObject: BallGameObject = .init()) {
        _gameObject = StateObject(wrappedValue: gameObject)
        id = gameObject.id
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
