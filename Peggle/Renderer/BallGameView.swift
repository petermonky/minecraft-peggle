//
//  BallGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/06.
//

import SwiftUI

struct BallGameView: View {
    let imageName: String
    let position: CGPoint

    init(gameObject: BallGameObject = .init()) {
        imageName = "ball"
        position = gameObject.position
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 2 * Constants.Ball.radius,
                   height: 2 * Constants.Ball.radius)
            .clipShape(Circle())
            .position(position)
    }
}

struct BallGameView_Previews: PreviewProvider {
    static var previews: some View {
        BallGameView()
    }
}
