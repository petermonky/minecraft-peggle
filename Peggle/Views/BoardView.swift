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
        let levelObjects = Array(viewModel.levelObjectViewModels)

        GeometryReader { geometry in
            ZStack {
                ForEach(levelObjects, id: \.self) { levelObject in
                    LevelObjectView(viewModel: levelObject)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .onTapGesture { location in
                if let levelObject = palette.createPegAtPosition(location) {
                    _ = viewModel.addLevelObject(LevelObjectViewModel(levelObject: levelObject))
                } else if let levelObject = palette.createBlockAtPosition(location) {
                    _ = viewModel.addLevelObject(LevelObjectViewModel(levelObject: levelObject))
                }
            }
            .onAppear {
                viewModel.initialiseBoardSize(boardSize: geometry.size)
            }
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
