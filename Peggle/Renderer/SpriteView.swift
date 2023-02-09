//
//  SpriteView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/08.
//

import SwiftUI

struct SpriteView: View {
    let spriteSheet: Image
    let width: CGFloat
    let height: CGFloat
    let frame: Int

    var body: some View {
        spriteSheet
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .offset(x: CGFloat(width / 2) - width * CGFloat(frame - 1))
            .clipped()
    }
}

struct SpriteView_Previews: PreviewProvider {
    static var previews: some View {
        SpriteView(
            spriteSheet: Image("cannon"),
            width: Constants.Cannon.width,
            height: Constants.Cannon.height,
            frame: 1
        )
    }
}
