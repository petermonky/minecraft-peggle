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
            .overlay(Color.white.opacity(isAfterImage ? 0.5 : 0.0))
            .frame(width: 80, height: 80)
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
                        _ = board.removePeg(viewModel.peg)
                    }
                }
                .onLongPressGesture {
                    _ = board.removePeg(viewModel.peg)
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.dragOffset = value.translation
                        }
                        .onEnded { value in
                            let pegSuccessfullyTranslated = board.translatePeg(viewModel.peg, translation: value.translation)
                            if !pegSuccessfullyTranslated {
                                viewModel.dragOffset = CGSizeZero
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
