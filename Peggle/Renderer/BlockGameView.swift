//
//  BlockGameView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct BlockGameView: View, Identifiable {
    @StateObject var gameObject: BlockGameObject
    @State var scale: Double
    @State var opacity: Double
    let id: String

    init(gameObject: BlockGameObject) {
        _gameObject = StateObject(wrappedValue: gameObject)
        scale = 1
        opacity = 1
        id = gameObject.id
    }

    var body: some View {
        Image(gameObject.block.normalImageName)
            .resizable()
            .scaledToFill()
            .frame(width: gameObject.shape.width,
                   height: gameObject.shape.height)
            .position(gameObject.position)
            .opacity(opacity)
            .onChange(of: gameObject.isVisible) { isVisible in
                withAnimation(.easeOut(duration: Constants.Peg.fadeDuration)) {
                    if !isVisible {
                        opacity = 0
                        scale = Constants.Peg.popScale
                    }
                }
            }
    }
}

struct BlockGameView_Previews: PreviewProvider {
    static var previews: some View {
        let blockGameObject = BlockGameObject(block: NormalBlock())
        BlockGameView(gameObject: blockGameObject)
    }
}
