//
//  LevelSelectionView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct LevelSelectionView: View {
    @StateObject var viewModel: LevelSelectionViewModel

    init(viewModel: LevelSelectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            ForEach(viewModel.levels) { level in
                NavigationLink(destination: GamePlayerView(
                    viewModel: GamePlayerViewModel(level: level)
                )) {
                    Text(level.title)
                }
            }
        }
        .task {
            do {
                try await viewModel.loadData()
            } catch {
                // TODO: proper error handling
                print("Error loading levels.")
            }
        }
        .navigationTitle("Levels")
    }
}

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LevelSelectionViewModel()
        LevelSelectionView(viewModel: viewModel)
    }
}
