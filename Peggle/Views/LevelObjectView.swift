//
//  LevelObjectView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import SwiftUI

struct LevelObjectView<Object>: View where Object: LevelObject {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    @StateObject var levelObject: Object

    init(levelObject: Object) {
        _levelObject = StateObject(wrappedValue: levelObject)
    }

    func renderBaseImage(isAfterImage: Bool) -> some View {
        Image(levelObject.normalImageName)
            .renderingMode(isAfterImage ? .template : .original)
            .resizable()
            .frame(width: levelObject.width,
                   height: levelObject.height)
            .rotationEffect(.radians(levelObject.rotationScale))
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
            .offset(levelObject.dragOffset)
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
                        levelObject.dragOffset = value.translation
                        levelObject.zIndex = Double.infinity
                    }
                    .onEnded { value in
                        let successfullyTranslated = levelDesigner.translateLevelObject(
                            levelObject,
                            translation: value.translation
                        )
                        if !successfullyTranslated {
                            levelObject.dragOffset = CGSize.zero
                        }
                        levelObject.zIndex = 0
                    }
            )
        }
        .zIndex(levelObject.zIndex)
    }
}

struct LevelObjectView_Previews: PreviewProvider {
    static var previews: some View {
        let levelObject = BluePeg()
        LevelObjectView(levelObject: levelObject)
            .environmentObject(LevelDesignerViewModel())
    }
}
