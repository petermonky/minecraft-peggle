//
//  LevelListView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/26.
//

import SwiftUI

struct LevelListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel
    let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }

    var body: some View {
        List {
            Button(action: {
                levelDesigner.resetLevel()
                dismiss()
            }) {
                Text("Create new level")
            }

            ForEach(levelDesigner.levels) { level in
                Button(action: {
                    levelDesigner.loadLevel(level)
                    dismiss()
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(level.title).font(.headline)
                            Text(level.updatedAt, formatter: dateFormatter).font(.subheadline)
                        }

                        Spacer()

                        Text("Currently open").isRendered(levelDesigner.isCurrentLevel(level))
                    }
                }
                .disabled(levelDesigner.isCurrentLevel(level))
            }
            .onDelete { indexSet in
                Task {
                    levelDesigner.deleteLevels(atOffsets: indexSet)
                    try await levelDesigner.saveData()
                }
            }
        }
        .toolbar {
            EditButton()
        }
        .task {
            do {
                try await levelDesigner.loadData()
            } catch {
                // TODO: proper error handling
                print("Error loading levels.")
            }
        }
        .navigationTitle("Levels")
    }
}

struct LevelListView_Previews: PreviewProvider {
    static var previews: some View {
        LevelListView()
            .environmentObject(LevelDesignerViewModel())
    }
}
