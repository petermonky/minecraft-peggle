//
//  PaletteViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import Foundation

extension PaletteView {
    class ViewModel: ObservableObject {
        @Published var mode: PaletteButtonType = .bluePeg
        @Published var pegFactory: PegFactory? = BluePegFactory()
        @Published var pegButtons: [PegPaletteButton] = [BluePegPaletteButton(), OrangePegPaletteButton()]
        @Published var deleteButton: PaletteButton = DeletePegPaletteButton()
        
        func onPegButtonSelect(pegButton: PegPaletteButton) {
            mode = pegButton.type
            pegFactory = pegButton.factory
        }
        
        func onDeleteButtonSelect() {
            mode = .delete
            pegFactory = nil
        }
    }
}
