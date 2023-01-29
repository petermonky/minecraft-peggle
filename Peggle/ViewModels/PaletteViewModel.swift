//  PaletteViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import Foundation

typealias PaletteViewModel = PaletteView.ViewModel

extension PaletteView {
    class ViewModel: ObservableObject {
        @Published var mode: PaletteButtonType
        @Published var pegFactory: PegFactory?
        @Published private var pegButtons: [PegPaletteButton]
        @Published private var deleteButton: PaletteButton

        init(
            mode: PaletteButtonType = .bluePeg,
            pegFactory: PegFactory? = BluePegFactory(),
            pegButtons: [PegPaletteButton] = [BluePegPaletteButton(), OrangePegPaletteButton()],
            deleteButton: PaletteButton = DeletePegPaletteButton()
        ) {
            self.mode = mode
            self.pegFactory = pegFactory
            self.pegButtons = pegButtons
            self.deleteButton = deleteButton
        }

        var pegButtonViewModels: [PaletteButtonViewModel] {
            pegButtons.map { PaletteButtonViewModel(paletteButton: $0) }
        }

        var deleteButtonViewModel: PaletteButtonViewModel {
            PaletteButtonViewModel(paletteButton: deleteButton)
        }

        func createPegAtPosition(_ position: CGPoint) -> Peg? {
            guard mode != .deletePeg else {
                return nil
            }
            return pegFactory?.createPegAtPosition(position)
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
