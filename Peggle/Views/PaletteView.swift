//
//  PaletteView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import SwiftUI

struct PaletteView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel

    var body: some View {
        HStack(spacing: 20) {
            ForEach(levelDesigner.pegPaletteButtons, id: \.type) { pegPaletteButton in
                PaletteButtonView(paletteButton: pegPaletteButton)
            }
            PaletteButtonView(paletteButton: levelDesigner.blockPaletteButton)
            Spacer()
            PaletteButtonView(paletteButton: levelDesigner.deletePaletteButton)
        }
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView()
            .environmentObject(LevelDesignerViewModel())
    }
}
