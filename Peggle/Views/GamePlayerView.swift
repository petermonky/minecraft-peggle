//
//  GamePlayerView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

 import SwiftUI

 struct GamePlayerView: View {
    @StateObject var viewModel: GamePlayerViewModel

    init(viewModel: GamePlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            RendererView(gameEngine: viewModel.gameEngine)
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
