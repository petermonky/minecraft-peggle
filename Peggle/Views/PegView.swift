//
//  PegView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import SwiftUI

struct PegView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    func renderBaseImage(isAfterImage: Bool) -> some View {
        Image(viewModel.peg.normalImageName)
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

        ZStack {
            renderBaseImage(isAfterImage: true)

            renderBaseImage(isAfterImage: false)
                .offset(viewModel.dragOffset)
                .onTapGesture {
                    if palette.mode == .deletePeg {
                        _ = board.removePeg(viewModel)
                    }
                }
                .onLongPressGesture {
                    _ = board.removePeg(viewModel)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.dragOffset = value.translation
                            viewModel.zIndex = Double.infinity
                        }
                        .onEnded { value in
                            let pegSuccessfullyTranslated = board.translatePeg(viewModel,
                                                                               translation: value.translation)
                            if !pegSuccessfullyTranslated {
                                viewModel.dragOffset = CGSize.zero
                            }
                            viewModel.zIndex = 0
                        }
                )
        }
        .zIndex(viewModel.zIndex)
    }
}

struct PegView_Previews: PreviewProvider {
    static var previews: some View {
        PegView()
            .environmentObject(LevelDesignerViewModel())
    }
}
