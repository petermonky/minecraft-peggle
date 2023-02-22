//
//  GamePlayerView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import SwiftUI

struct GamePlayerView: View {
    @StateObject var viewModel: GamePlayerViewModel

    var body: some View {
        VStack {
//            HStack {
//                Text("test")
//            }
//            .frame(height: 180)
            RendererView(renderer: viewModel.renderer)
               .environment(\.colorScheme, .light)
               .ignoresSafeArea(.container)
        }
    }
}

struct GamePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GamePlayerViewModel(level: Level.mockData)
        GamePlayerView(viewModel: viewModel)
    }
}
