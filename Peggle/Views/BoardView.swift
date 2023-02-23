//
//  BoardView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/21.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(levelDesigner.levelObjects, id: \.id) { levelObject in
                    LevelObjectView(levelObject: levelObject)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .onTapGesture { location in
                levelDesigner.createObjectAtPosition(location)
            }
            .onAppear {
                levelDesigner.initialiseBoardSize(boardSize: geometry.size)
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
