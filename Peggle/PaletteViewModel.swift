//
//  PaletteViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import Foundation

extension PaletteView {
    class ViewModel: ObservableObject {
        @Published var mode: PaletteButtonType
        @Published var pegFactory: PegFactory?
        @Published var pegButtons: [PegPaletteButton] = [BluePegPaletteButton(), OrangePegPaletteButton()]
        @Published var deleteButton: PaletteButton = DeletePegPaletteButton()
        
        init(mode: PaletteButtonType = .bluePeg, pegFactory: PegFactory? = BluePegFactory()) {
            self.mode = mode
            self.pegFactory = pegFactory
        }
        
        func onPegButtonSelect(pegButton: PegPaletteButton) {
            mode = pegButton.type
            pegFactory = pegButton.factory
        }
        
        func onDeleteButtonSelect() {
            mode = .deletePeg
            pegFactory = nil
        }
    }
}
