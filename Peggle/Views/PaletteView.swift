//
//  PaletteView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import SwiftUI

struct PaletteView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerView.ViewModel
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        HStack {
            ForEach(viewModel.pegButtonViewModels) { pegButtonViewModel in
                PaletteButtonView(viewModel: pegButtonViewModel)
            }

            Spacer()

            PaletteButtonView(viewModel: viewModel.deleteButtonViewModel)
        }
        .padding()
        .background(Color.white)
        .environmentObject(levelDesigner)
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView()
            .environmentObject(LevelDesignerView.ViewModel())
    }
}
