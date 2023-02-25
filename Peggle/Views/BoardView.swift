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
                    if let peg = levelObject as? Peg {
                        LevelObjectView(levelObject: peg)
                    } else if let block = levelObject as? Block {
                        LevelObjectView(levelObject: block)
                    }
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
                levelDesigner.initialiseFrame(size: geometry.size)
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
