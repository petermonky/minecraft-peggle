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

                    ForEach(levelDesigner.levels.reversed()) { level in
                        Button(action: {
                            levelDesigner.loadLevel(level)
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(level.title)
                                        .font(.custom("Minecraft-Bold", size: 20)).bold()
                                    Text(level.updatedAt, formatter: dateFormatter)
                                        .font(.custom("Minecraft-Regular", size: 16))
                                }
                                Spacer()
                                HStack {
                                    HStack {
                                        Image("peg-blue").resizable().scaledToFit().frame(width: 24, height: 24)
                                        Text("\(level.pegs.filter { $0.type == .blue }.count)")
                                            .font(.custom("Minecraft-Regular", size: 16))
                                            .frame(width: 32, alignment: .leading)
                                    }
                                    HStack {
                                        Image("peg-red").resizable().scaledToFit().frame(width: 24, height: 24)
                                        Text("\(level.pegs.filter { $0.type == .red }.count)")
                                            .font(.custom("Minecraft-Regular", size: 16))
                                            .frame(width: 32, alignment: .leading)
                                    }
                                    HStack {
                                        Image("peg-green").resizable().scaledToFit().frame(width: 24, height: 24)
                                        Text("\(level.pegs.filter { $0.type == .green }.count)")
                                            .font(.custom("Minecraft-Regular", size: 16))
                                            .frame(width: 32, alignment: .leading)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(GrayButton())
                    }
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
}

struct LevelListView_Previews: PreviewProvider {
    static var previews: some View {
        LevelListView()
            .environmentObject(LevelDesignerViewModel())
    }
}
