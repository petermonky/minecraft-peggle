//
//  BoardView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/21.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerView.ViewModel
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        let palette = levelDesigner.paletteViewModel
        
        GeometryReader { geometry in
            ZStack {
                ForEach(viewModel.pegViewModels, id: \.self) { pegViewModel in
                    PegView(viewModel: pegViewModel)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .onTapGesture { location in
                if palette.mode != .deletePeg {
                    let pegFactory = palette.pegFactory
                    if let peg = pegFactory?.createPegAtPosition(location) {
                        _ = viewModel.addPeg(peg)
                    }
                }
            }
            .onAppear {
                viewModel.boardSize = geometry.size
            }
        }
        .environmentObject(viewModel)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(LevelDesignerView.ViewModel())
    }
}
