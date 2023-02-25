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
                NavigationLink(destination: LevelListView().environmentObject(levelDesigner)) {
                    Text("Load")
                }.simultaneousGesture(TapGesture().onEnded {
                    hideKeyboard()
                })

                Button(action: {
                    Task {
                        do {
                            try await levelDesigner.saveLevel()
                        } catch {
                            // TODO: proper error handling
                            print("Error saving levels.")
                        }
                    }
                }) {
                    Text("Save")
                }.disabled(levelDesigner.level.title.isEmpty)

                Button(action: {
                    levelDesigner.resetLevelObjects()
                }) {
                    Text("Reset")
                }
            }

            TextField("Enter level title", text: $levelDesigner.level.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            NavigationLink(destination: NavigationLazyView(GamePlayerView(viewModel: GamePlayerViewModel(level: levelDesigner.level)))) {
                Text("Start")
            }.simultaneousGesture(TapGesture().onEnded {
                hideKeyboard()
            })

//            NavigationLink(destination: GamePlayerView(
//                viewModel: GamePlayerViewModel(level: levelDesigner.level)
//            )) {
//                Text("START")
//            }.simultaneousGesture(TapGesture().onEnded {
//                hideKeyboard()
//            })
        }
        .font(.custom("Minecraft-Regular", size: 20))
    }
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
            .environmentObject(LevelDesignerViewModel())
    }
}
