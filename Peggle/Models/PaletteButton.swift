//
//  PaletteButton.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

enum PaletteButtonType: String {
    case bluePeg   = "peg-blue"
    case orangePeg = "peg-orange"
    case greenPeg  = "peg-green"
    case block     = "block"
    case delete = "delete"
}

protocol PaletteButton {
    var type: PaletteButtonType { get set }
    var imageName: String { get }

    func updatePalette(_ levelDesigner: LevelDesignerViewModel)
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

    @MainActor func updatePalette(_ levelDesigner: LevelDesignerViewModel) {
        levelDesigner.onPegButtonSelect(pegButton: self)
    }
}

struct OrangePegPaletteButton: PegPaletteButton {
    var type: PaletteButtonType = .orangePeg
    var factory: PegFactory = OrangePegFactory()

    @MainActor func updatePalette(_ levelDesigner: LevelDesignerViewModel) {
        levelDesigner.onPegButtonSelect(pegButton: self)
    }
}

struct GreenPegPaletteButton: PegPaletteButton {
    var type: PaletteButtonType = .greenPeg
    var factory: PegFactory = GreenPegFactory()

    @MainActor func updatePalette(_ levelDesigner: LevelDesignerViewModel) {
        levelDesigner.onPegButtonSelect(pegButton: self)
    }
}

struct BlockPaletteButton: PaletteButton {
    var type: PaletteButtonType = .block

    @MainActor func updatePalette(_ levelDesigner: LevelDesignerViewModel) {
        levelDesigner.onBlockButtonSelect()
    }
}

struct DeletePegPaletteButton: PaletteButton {
    var type: PaletteButtonType = .delete

    @MainActor func updatePalette(_ levelDesigner: LevelDesignerViewModel) {
        levelDesigner.onDeleteButtonSelect()
    }
}
