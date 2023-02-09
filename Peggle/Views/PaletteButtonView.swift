//
//  PaletteButtonView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import SwiftUI

struct PaletteButtonView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let palette = levelDesigner.paletteViewModel
        let paletteButton = viewModel.paletteButton

        Button(action: {
            viewModel.updatePalette(palette)
        }) {
            Image(paletteButton.imageName)
                .resizable()
                .frame(width: Constants.PaletteButton.width,
                       height: Constants.PaletteButton.height)
                .overlay(Color.white.opacity(
                    palette.mode == paletteButton.type
                    ? Constants.PaletteButton.selectedOpacity
                    : 0.0))
                .clipShape(Circle())
        }
    }
}

struct PaletteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteButtonView()
            .environmentObject(LevelDesignerViewModel())
    }
}
