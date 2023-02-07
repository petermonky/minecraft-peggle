//
//  PegGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import SwiftUI

struct PegGameView: View {
    let imageName: String
    let position: CGPoint

    init(gameObject: PegGameObject = .init()) {
        imageName = gameObject.peg.imageName
        position = gameObject.position
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 2 * Constants.Peg.radius,
                   height: 2 * Constants.Peg.radius)
            .clipShape(Circle())
            .position(position)
    }
}

struct PegGameView_Previews: PreviewProvider {
    static var previews: some View {
        PegGameView()
    }
}
