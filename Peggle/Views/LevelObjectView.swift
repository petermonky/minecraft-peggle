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

    var body: some View {
        renderObject()
        .onAppear {
            levelObject.callibrateSizeScale()
            levelObject.callibrateRotationScale()
        }
        .zIndex(levelObject.zIndex)
    }

    private func renderObject() -> some View {
        ZStack {
            renderAfterImage()
            renderTrueImage()
                .offset(levelObject.dragOffset)
                .onTapGesture {
                    if levelDesigner.mode == .delete {
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
    }

    private func renderAfterImage() -> some View {
        renderBaseImage(isAfterImage: true)
            .foregroundColor(.white.opacity(Constants.LevelObject.afterImageOpacity))
    }

    private func renderTrueImage() -> some View {
        let isSelected = levelDesigner.isCurrentLevelObject(levelObject)

        return ZStack {
            renderBaseImage(isAfterImage: false)
            renderBaseImage(isAfterImage: true)
                .foregroundColor(.white.opacity(isSelected
                                                ? Constants.LevelObject.afterImageOpacity
                                                : 0.0))
        }
    }

    private func renderBaseImage(isAfterImage: Bool) -> some View {
        Image(levelObject.normalImageName)
            .renderingMode(isAfterImage ? .template : .original)
            .resizable()
            .frame(width: levelObject.width,
                   height: levelObject.height)
            .rotationEffect(.radians(levelObject.rotationScale))
            .position(levelObject.position)
    }
}

struct LevelObjectView_Previews: PreviewProvider {
    static var previews: some View {
        let levelObject = BluePeg()
        LevelObjectView(levelObject: levelObject)
            .environmentObject(LevelDesignerViewModel())
    }
}
