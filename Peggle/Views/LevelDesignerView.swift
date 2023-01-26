//
//  LevelDesignerView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import SwiftUI

struct LevelDesignerView: View {
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BoardView(viewModel: viewModel.boardViewModel)
                VStack(spacing: 24) {
                    PaletteView(viewModel: viewModel.paletteViewModel)
                    ActionView(viewModel: viewModel.actionViewModel)
                }
                .padding()
            }
            .ignoresSafeArea(.container, edges: .top)
        }
        .task {
            do {
                try await viewModel.loadData()
            } catch {
                // TODO: proper error handling
                print("Error loading levels.")
            }
        }
        .environmentObject(viewModel)
    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView()
    }
}
