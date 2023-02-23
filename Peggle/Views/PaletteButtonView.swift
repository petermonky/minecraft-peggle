//
//  PaletteButtonView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import SwiftUI

struct PaletteButtonView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    var paletteButton: PaletteButton

    init(paletteButton: PaletteButton) {
        self.paletteButton = paletteButton
    }

    var body: some View {
        Button(action: {
            paletteButton.updatePalette(levelDesigner)
        }) {
            Image(paletteButton.imageName)
                .resizable()
                .frame(width: Constants.PaletteButton.width,
                       height: Constants.PaletteButton.height)
                .overlay(Color.white.opacity(
                    levelDesigner.mode == paletteButton.type
                    ? Constants.PaletteButton.selectedOpacity
                    : 0.0))
        }
    }
}

struct PaletteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteButtonView(paletteButton: BluePegPaletteButton())
            .environmentObject(LevelDesignerViewModel())
    }
}
