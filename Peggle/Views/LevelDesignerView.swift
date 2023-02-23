//
//  LevelDesignerView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import SwiftUI

struct LevelDesignerView: View {
    @StateObject var viewModel: LevelDesignerViewModel

    init(viewModel: LevelDesignerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            DataView()
            BoardView()
            VStack {
                PaletteView()
                Spacer()
                ActionView()
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
        let viewModel = LevelDesignerViewModel()
        LevelDesignerView(viewModel: viewModel)
    }
}
