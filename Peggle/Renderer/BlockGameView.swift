//
//  BlockGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct BlockGameView: View, Identifiable {
    @StateObject var gameObject: BlockGameObject
    let id: String

    init(gameObject: BlockGameObject) {
        _gameObject = StateObject(wrappedValue: gameObject)
        id = gameObject.id
    }

    var body: some View {
        Image(gameObject.block.normalImageName)
            .resizable()
            .scaledToFill()
            .frame(width: Constants.Block.width,
                   height: Constants.Block.height)
            .position(gameObject.position)
//            .opacity(opacity)
//            .onChange(of: gameObject.isVisible) { isVisible in
//                withAnimation(.easeOut(duration: Constants.Peg.fadeDuration)) {
//                    if !isVisible {
//                        opacity = 0
//                        scale = Constants.Peg.popScale
//                    }
//                }
//            }
    }
}

struct BlockGameView_Previews: PreviewProvider {
    static var previews: some View {
        let blockGameObject = BlockGameObject(block: NormalBlock())
        BlockGameView(gameObject: blockGameObject)
    }
}
