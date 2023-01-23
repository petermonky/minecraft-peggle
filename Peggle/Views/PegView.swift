//
//  PegView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import SwiftUI

struct PegView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerView.ViewModel
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    func renderBaseImage(isAfterImage: Bool) -> some View {
        Image(viewModel.peg.imageName)
            .resizable()
            .overlay(Color.white.opacity(isAfterImage
                                         ? Constants.Peg.afterImageOpacity
                                         : 0.0))
            .frame(width: 2 * Constants.Peg.radius,
                   height: 2 * Constants.Peg.radius)
            .clipShape(Circle())
            .position(viewModel.peg.position)
    }

    var body: some View {
        let palette = levelDesigner.paletteViewModel
        let board = levelDesigner.boardViewModel
        let peg = viewModel.peg

        ZStack {
            renderBaseImage(isAfterImage: true)

            renderBaseImage(isAfterImage: false)
                .offset(viewModel.dragOffset)
                .onTapGesture {
                    if palette.mode == .deletePeg {
                        _ = board.removePeg(peg)
                    }
                }
                .onLongPressGesture {
                    _ = board.removePeg(peg)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.dragOffset = value.translation
                        }
                        .onEnded { value in
                            let pegSuccessfullyTranslated = board.translatePeg(peg, translation: value.translation)
                            if !pegSuccessfullyTranslated {
                                viewModel.dragOffset = CGSize.zero
                            }
                        }
                )
        }
    }
}

struct PegView_Previews: PreviewProvider {
    static var previews: some View {
        PegView()
            .environmentObject(LevelDesignerView.ViewModel())
    }
}
