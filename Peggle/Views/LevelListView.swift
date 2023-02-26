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
        GeometryReader { _ in
            ScrollView {
                VStack(spacing: 12) {
                    renderCreateNewLevelButton()
                    renderLevels()
                }
                .padding(.vertical, 140)
                .padding(.horizontal, 60)
                .frame(maxWidth: .infinity)
                .task {
                    do {
                        try await levelDesigner.loadData()
                    } catch {
                        // TODO: proper error handling
                        print("Error loading levels.")
                    }
                }
            }
        }
        .background(
            Image("background-stone")
                .resizable(resizingMode: .tile)
                .overlay(.black.opacity(0.25))
        )
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
    }

    private func renderCreateNewLevelButton() -> some View {
        Button(action: {
            levelDesigner.resetLevel()
            dismiss()
        }) {
            Text("Create new level")
                .font(.custom("Minecraft-Bold", size: 16)).bold()
                .frame(height: 24)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(GrayButton())
    }

    private func renderLevels() -> some View {
        ForEach(levelDesigner.levels.reversed()) { level in
            Button(action: {
                levelDesigner.loadLevel(level)
                dismiss()
            }) {
                HStack {
                    renderLevelTitleAndDate(level: level)
                    Spacer()
                    HStack {
                        renderPegLabel(imageName: "peg-blue", pegType: .blue, level: level)
                        renderPegLabel(imageName: "peg-red", pegType: .red, level: level)
                        renderPegLabel(imageName: "peg-green", pegType: .green, level: level)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(GrayButton())
        }
    }

    private func renderLevelTitleAndDate(level: Level) -> some View {
        VStack(alignment: .leading) {
            Text(level.title)
                .font(.custom("Minecraft-Bold", size: 20)).bold()
            Text(level.updatedAt, formatter: dateFormatter)
                .font(.custom("Minecraft-Regular", size: 16))
        }
    }

    private func renderPegLabel(imageName: String, pegType: PegType, level: Level) -> some View {
        HStack {
            Image(imageName).resizable().scaledToFit().frame(width: 24, height: 24)
            Text("\(level.pegs.filter { $0.type == pegType }.count)")
                .font(.custom("Minecraft-Regular", size: 16))
                .frame(width: 32, alignment: .leading)
        }
    }
}

struct LevelListView_Previews: PreviewProvider {
    static var previews: some View {
        LevelListView()
            .environmentObject(LevelDesignerViewModel())
    }
}
