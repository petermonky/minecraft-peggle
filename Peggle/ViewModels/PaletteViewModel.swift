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
        @Published private var blockButton: PaletteButton
        @Published private var deleteButton: PaletteButton

        init(
            mode: PaletteButtonType = .bluePeg,
            pegFactory: PegFactory? = BluePegFactory(),
            pegButtons: [PegPaletteButton] = [BluePegPaletteButton(), OrangePegPaletteButton()],
            blockButton: PaletteButton = BlockPaletteButton(),
            deleteButton: PaletteButton = DeletePegPaletteButton()
        ) {
            self.mode = mode
            self.pegFactory = pegFactory
            self.pegButtons = pegButtons
            self.blockButton = blockButton
            self.deleteButton = deleteButton
        }

        var pegButtonViewModels: [PaletteButtonViewModel] {
            pegButtons.map { PaletteButtonViewModel(paletteButton: $0) }
        }

        var blockButtonViewModel: PaletteButtonViewModel {
            PaletteButtonViewModel(paletteButton: blockButton)
        }

        var deleteButtonViewModel: PaletteButtonViewModel {
            PaletteButtonViewModel(paletteButton: deleteButton)
        }

        func createBlockAtPosition(_ position: CGPoint) -> Block? {
            guard mode == .block else {
                return nil
            }
            return NormalBlock(position: position)
        }

        func createPegAtPosition(_ position: CGPoint) -> Peg? {
            guard mode != .deletePeg && mode != .block else {
                return nil
            }
            return pegFactory?.createPegAtPosition(position)
        }

        func onPegButtonSelect(pegButton: PegPaletteButton) {
            mode = pegButton.type
            pegFactory = pegButton.factory
        }

        func onBlockButtonSelect() {
            mode = .block
            pegFactory = nil
        }

        func onDeleteButtonSelect() {
            mode = .deletePeg
            pegFactory = nil
        }
    }
}
