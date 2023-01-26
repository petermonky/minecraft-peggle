//  PaletteButtonViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import Foundation

typealias PaletteButtonViewModel = PaletteButtonView.ViewModel

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

// MARK: PaletteButton

enum PaletteButtonType: String {
    case bluePeg   = "peg-blue"
    case orangePeg = "peg-orange"
    case deletePeg = "delete"
}

protocol PaletteButton {
    var type: PaletteButtonType { get set }
    var imageName: String { get }

    func updatePalette(_ palette: PaletteViewModel)
}

extension PaletteButton {
    var imageName: String {
        type.rawValue
    }
}

protocol PegPaletteButton: PaletteButton {
    var factory: PegFactory { get set }
}

struct BluePegPaletteButton: PegPaletteButton {
    var type: PaletteButtonType = .bluePeg
    var factory: PegFactory = BluePegFactory()

    func updatePalette(_ palette: PaletteViewModel) {
        palette.onPegButtonSelect(pegButton: self)
    }
}

struct OrangePegPaletteButton: PegPaletteButton {
    var type: PaletteButtonType = .orangePeg
    var factory: PegFactory = OrangePegFactory()

    func updatePalette(_ palette: PaletteViewModel) {
        palette.onPegButtonSelect(pegButton: self)
    }
}

struct DeletePegPaletteButton: PaletteButton {
    var type: PaletteButtonType = .deletePeg

    func updatePalette(_ palette: PaletteViewModel) {
        palette.onDeleteButtonSelect()
    }
}
