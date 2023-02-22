//
//  BoardView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/21.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let palette = levelDesigner.paletteViewModel
        let pegs = Array(viewModel.pegViewModels)

        GeometryReader { geometry in
            ZStack {
                ForEach(pegs, id: \.self) { peg in
                    PegView(viewModel: peg)
                }
            }
//            .scaleEffect(x: viewModel.sizeScale, y: viewModel.sizeScale, anchor: .top)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .onTapGesture { location in
                if let peg = palette.createPegAtPosition(location) {
                    _ = viewModel.addPeg(PegViewModel(peg: peg))
                }
            }
            .onAppear {
                viewModel.initialiseBoardSize(boardSize: geometry.size)
            }
//            .onChange(of: geometry.size) { _ in
//                withAnimation(.easeOut(duration: 0.225)) {
//                    print(geometry.size)
//                    viewModel.updateBoardSize(boardSize: geometry.size)
//                }
//            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            hideKeyboard()
        })
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(LevelDesignerViewModel())
    }
}
