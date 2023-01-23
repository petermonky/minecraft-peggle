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
        @Published private var pegButtons: [PegPaletteButton] = [BluePegPaletteButton(), OrangePegPaletteButton()]
        @Published private var deleteButton: PaletteButton = DeletePegPaletteButton()
        
        init(mode: PaletteButtonType = .bluePeg, pegFactory: PegFactory? = BluePegFactory()) {
            self.mode = mode
            self.pegFactory = pegFactory
        }
        
        var pegButtonViewModels: [PaletteButtonView.ViewModel] {
            pegButtons.map{ PaletteButtonView.ViewModel(paletteButton: $0) }
        }
        
        var deleteButtonViewModel: PaletteButtonView.ViewModel {
            PaletteButtonView.ViewModel(paletteButton: deleteButton)
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
