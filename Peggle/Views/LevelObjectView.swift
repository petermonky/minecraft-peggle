//
//  LevelObjectView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import SwiftUI

struct LevelObjectView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    @State var dragOffset = CGSize.zero
    @State var zIndex: Double = 0
    private var levelObject: any LevelObject

    init(levelObject: any LevelObject) {
        self.levelObject = levelObject
    }

    func renderBaseImage(isAfterImage: Bool) -> some View {
        Image(levelObject.normalImageName)
            .renderingMode(isAfterImage ? .template : .original)
            .resizable()
            .frame(width: levelObject.width,
                   height: levelObject.height)
            .position(levelObject.position)
    }

    var body: some View {
        let isSelected = levelDesigner.isSelectedLevelObject(levelObject)

        ZStack {
            renderBaseImage(isAfterImage: true)
                .foregroundColor(.white.opacity(Constants.LevelObject.afterImageOpacity))

            ZStack {
                renderBaseImage(isAfterImage: false)
                renderBaseImage(isAfterImage: true)
                    .foregroundColor(.white.opacity(isSelected
                                                    ? Constants.LevelObject.afterImageOpacity
                                                    : 0.0))
            }
            .offset(dragOffset)
            .onTapGesture {
                if levelDesigner.mode == .deletePeg {
                    _ = levelDesigner.removeLevelObject(levelObject)
                } else {
                    levelDesigner.selectLevelObject(levelObject)
                }
            }
            .onLongPressGesture {
                _ = levelDesigner.removeLevelObject(levelObject)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                        zIndex = Double.infinity
                    }
                    .onEnded { value in
                        let successfullyTranslated = levelDesigner.translateLevelObject(
                            levelObject,
                            translation: value.translation
                        )
                        if !successfullyTranslated {
                            dragOffset = CGSize.zero
                        }
                        zIndex = 0
                    }
            )
        }
        .zIndex(zIndex)
    }
}

struct LevelObjectView_Previews: PreviewProvider {
    static var previews: some View {
        let levelObject = BluePeg()
        LevelObjectView(levelObject: levelObject)
            .environmentObject(LevelDesignerViewModel())
    }
}
