//
//  PaletteButton.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation

enum PaletteButtonType {
    case bluePeg
    case orangePeg
    case deletePeg
}

protocol PaletteButton {
    typealias PaletteViewModel = PaletteView.ViewModel

    var type: PaletteButtonType { get set }
    var imageName: String { get set }

    func updatePalette(_ palette: PaletteViewModel)
}

protocol PegPaletteButton: PaletteButton {
    var factory: PegFactory { get set }
}

struct BluePegPaletteButton: PegPaletteButton {
    var type: PaletteButtonType = .bluePeg
    var imageName = "peg-blue"
    var factory: PegFactory = BluePegFactory()

    func updatePalette(_ palette: PaletteViewModel) {
        palette.onPegButtonSelect(pegButton: self)
    }
}

struct OrangePegPaletteButton: PegPaletteButton {
    var type: PaletteButtonType = .orangePeg
    var imageName = "peg-orange"
    var factory: PegFactory = OrangePegFactory()

    func updatePalette(_ palette: PaletteViewModel) {
        palette.onPegButtonSelect(pegButton: self)
    }
}

struct DeletePegPaletteButton: PaletteButton {
    var type: PaletteButtonType = .deletePeg
    var imageName = "delete"

    func updatePalette(_ palette: PaletteViewModel) {
        palette.onDeleteButtonSelect()
    }
}
