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
        VStack(spacing: 0) {
            DataView()
            BoardView(viewModel: viewModel.boardViewModel)
            VStack {
                PaletteView(viewModel: viewModel.paletteViewModel)
                Spacer()
                ActionView(viewModel: viewModel.actionViewModel)
            }
            .frame(height: 180)
            .padding(20)
        }
        .task {
            do {
                try await viewModel.loadData()
            } catch {
                // TODO: proper error handling
                print("Error loading levels.")
            }
        }
        .ignoresSafeArea(edges: .all)
        .environmentObject(viewModel)
    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView()
    }
}
