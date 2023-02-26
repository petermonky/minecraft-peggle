//
//  ActionView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import SwiftUI

struct ActionView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel

    var body: some View {
        HStack(spacing: 24) {
            HStack(spacing: 20) {
                renderLoadButton()
                renderSaveButton()
                renderResetButton()
            }
            TextField("Enter level title", text: $levelDesigner.level.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            renderStartButton()
        }
        .font(.custom("Minecraft-Regular", size: 20))
    }

    private func renderLoadButton() -> some View {
        NavigationLink(destination: LevelListView().environmentObject(levelDesigner)) {
            Text("Load")
        }.simultaneousGesture(TapGesture().onEnded {
            hideKeyboard()
        })
    }

    private func renderSaveButton() -> some View {
        Button(action: {
            Task {
                do {
                    try await levelDesigner.saveLevel()
                } catch {
                    print("Error saving levels.")
                }
            }
        }) {
            Text("Save")
        }.disabled(levelDesigner.level.title.isEmpty)
    }

    private func renderResetButton() -> some View {
        Button(action: {
            levelDesigner.resetLevelObjects()
        }) {
            Text("Reset")
        }
    }

    private func renderStartButton() -> some View {
        NavigationLink(destination: NavigationLazyView(
            GamePlayerView(viewModel: GamePlayerViewModel(level: levelDesigner.level))
        )) {
            Text("Start")
        }.simultaneousGesture(TapGesture().onEnded {
            hideKeyboard()
        })
    }
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
            .environmentObject(LevelDesignerViewModel())
    }
}
