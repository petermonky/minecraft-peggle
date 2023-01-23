//  swiftlint:disable:this file_name
//
//  PaletteButtonViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import Foundation

extension PaletteButtonView {
    class ViewModel: ObservableObject {
        @Published var paletteButton: PaletteButton

        init(paletteButton: PaletteButton = BluePegPaletteButton()) {
            self.paletteButton = paletteButton
        }
    }
}

// MARK: Identifiable

extension PaletteButtonView.ViewModel: Identifiable {
}
