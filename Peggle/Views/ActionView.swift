//
//  ActionView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import SwiftUI

struct ActionView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let board = levelDesigner.boardViewModel
        let levelList = levelDesigner.levelListViewModel

        HStack(spacing: 24) {
            HStack {
                NavigationLink(destination: LevelListView(viewModel: levelList).environmentObject(levelDesigner)) {
                    Text("LOAD")
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
                    Text("SAVE")
                }.disabled(!viewModel.isValidForm)

                Button(action: {
                    board.resetLevelObjects()
                }) {
                    Text("RESET")
                }
            }

            TextField("Enter level title", text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
            }) {
                Text("START")
            }
        }
    }
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
            .environmentObject(LevelDesignerViewModel())
    }
}
