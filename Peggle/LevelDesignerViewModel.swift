//
//  LevelDesignerViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import Foundation

extension LevelDesignerView {
    class ViewModel: ObservableObject {
        @Published var paletteViewModel = PaletteView.ViewModel()
        @Published var boardViewModel = BoardView.ViewModel(pegs: [])
    }
}
