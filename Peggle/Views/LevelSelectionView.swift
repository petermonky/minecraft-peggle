//
//  LevelSelectionView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct LevelSelectionView: View {
    @StateObject var viewModel: LevelSelectionViewModel

    init(viewModel: LevelSelectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { _ in
            ScrollView {
                VStack(spacing: 12) {
                    renderCreatedLevels()
                    renderPresetLevels()
                }
                .padding(.vertical, 140)
                .padding(.horizontal, 60)
                .frame(maxWidth: .infinity)
                .task {
                    do {
                        try await viewModel.loadData()
                    } catch {
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

    private func renderCreatedLevels() -> some View {
        ForEach(viewModel.levels.reversed()) { level in
            NavigationLink(destination: NavigationLazyView(GamePlayerView(
                viewModel: GamePlayerViewModel(level: level)
            ))) {
                HStack {
                    Text(level.title)
                        .font(.custom("Minecraft-Bold", size: 20)).bold()
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

    private func renderPresetLevels() -> some View {
        NavigationLink(destination: NavigationLazyView(GamePlayerView(
            viewModel: GamePlayerViewModel(level: Level.mockData)
        ))) {
            HStack {
                Text(Level.mockData.title)
                    .font(.custom("Minecraft-Bold", size: 20)).bold()
                Spacer()
                HStack {
                    renderPegLabel(imageName: "peg-blue", pegType: .blue, level: Level.mockData)
                    renderPegLabel(imageName: "peg-red", pegType: .red, level: Level.mockData)
                    renderPegLabel(imageName: "peg-green", pegType: .green, level: Level.mockData)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(GrayButton())
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

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LevelSelectionViewModel()
        LevelSelectionView(viewModel: viewModel)
    }
}
