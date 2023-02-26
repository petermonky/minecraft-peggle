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
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 20) {
                    ForEach(levelDesigner.normalPegPaletteButtons, id: \.type) {
                        PaletteButtonView(paletteButton: $0)
                    }
                }
                HStack(spacing: 20) {
                    PaletteButtonView(paletteButton: levelDesigner.blockPaletteButton)
                }
            }
            Spacer()
            VStack(spacing: 16) {
                VStack {
                    Text("Size")
                        .font(.custom("Minecraft-Bold", size: 20))
                    Slider(value: $levelDesigner.resizeValue, in: 0.25...1.75)
                        .onChange(of: levelDesigner.resizeValue, perform: sliderChanged )
                        .disabled(!levelDesigner.isLevelObjectSelected)
                }
                VStack {
                    Text("Amgle")
                        .font(.custom("Minecraft-Bold", size: 20))
                    Slider(value: $levelDesigner.rotateValue, in: -Double.pi...Double.pi)
                        .onChange(of: levelDesigner.rotateValue, perform: sliderChanged )
                        .disabled(!levelDesigner.isLevelObjectSelected)
                }
            }
            Spacer()
            PaletteButtonView(paletteButton: levelDesigner.deletePaletteButton)
        }
    }

    private func sliderChanged(to newValue: Double) {
        _ = levelDesigner.refreshLevelObject()
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView()
            .environmentObject(LevelDesignerViewModel())
    }
}
