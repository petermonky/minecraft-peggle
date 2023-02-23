//
//  LevelObjectView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import SwiftUI

struct LevelObjectView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    @StateObject var viewModel: LevelObjectViewModel

    init(viewModel: LevelObjectViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    func renderBaseImage(isAfterImage: Bool) -> some View {
        Image(viewModel.levelObject.normalImageName)
            .renderingMode(isAfterImage ? .template : .original)
            .resizable()
            .foregroundColor(.white)
            .opacity(isAfterImage
                     ? Constants.Peg.afterImageOpacity
                     : 1.0)
            .frame(width: viewModel.levelObject.width,
                   height: viewModel.levelObject.height)
            .position(viewModel.levelObject.position)
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
                        _ = board.removeLevelObject(viewModel)
                    }
                }
                .onLongPressGesture {
                    _ = board.removeLevelObject(viewModel)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.dragOffset = value.translation
                            viewModel.zIndex = Double.infinity
                        }
                        .onEnded { value in
                            let successfullyTranslated = board.translateLevelObject(viewModel,
                                                                                    translation: value.translation)
                            if !successfullyTranslated {
                                viewModel.dragOffset = CGSize.zero
                            }
                            viewModel.zIndex = 0
                        }
                )
        }
        .zIndex(viewModel.zIndex)
    }
}

struct LevelObjectView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LevelObjectViewModel(levelObject: BluePeg())
        LevelObjectView(viewModel: viewModel)
            .environmentObject(LevelDesignerViewModel())
    }
}
