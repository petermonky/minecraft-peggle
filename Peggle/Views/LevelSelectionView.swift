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
                    ForEach(viewModel.levels.reversed()) { level in
                        NavigationLink(destination: NavigationLazyView(GamePlayerView(
                            viewModel: GamePlayerViewModel(level: level)
                        ))) {
                            HStack {
                                Text(level.title)
                                    .font(.custom("Minecraft-Bold", size: 20)).bold()
                                Spacer()
                                HStack {
                                    HStack {
                                        Image("peg-blue").resizable().scaledToFit().frame(width: 24, height: 24)
                                        Text("\(level.pegs.filter { $0.type == .blue }.count)")
                                            .font(.custom("Minecraft-Regular", size: 16))
                                            .frame(width: 32, alignment: .leading)
                                    }
                                    HStack {
                                        Image("peg-orange").resizable().scaledToFit().frame(width: 24, height: 24)
                                        Text("\(level.pegs.filter { $0.type == .orange }.count)")
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
                    NavigationLink(destination: NavigationLazyView(GamePlayerView(
                        viewModel: GamePlayerViewModel(level: Level.mockData)
                    ))) {
                        HStack {
                            Text(Level.mockData.title)
                                .font(.custom("Minecraft-Bold", size: 20)).bold()
                            Spacer()
                            HStack {
                                HStack {
                                    Image("peg-blue").resizable().scaledToFit().frame(width: 24, height: 24)
                                    Text("\(Level.mockData.pegs.filter { $0.type == .blue }.count)")
                                        .font(.custom("Minecraft-Regular", size: 16))
                                        .frame(width: 32, alignment: .leading)
                                }
                                HStack {
                                    Image("peg-orange").resizable().scaledToFit().frame(width: 24, height: 24)
                                    Text("\(Level.mockData.pegs.filter { $0.type == .orange }.count)")
                                        .font(.custom("Minecraft-Regular", size: 16))
                                        .frame(width: 32, alignment: .leading)
                                }
                                HStack {
                                    Image("peg-green").resizable().scaledToFit().frame(width: 24, height: 24)
                                    Text("\(Level.mockData.pegs.filter { $0.type == .green }.count)")
                                        .font(.custom("Minecraft-Regular", size: 16))
                                        .frame(width: 32, alignment: .leading)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GrayButton())
                }
                .padding(.vertical, 140)
                .padding(.horizontal, 60)
                .frame(maxWidth: .infinity)
                .task {
                    do {
                        try await viewModel.loadData()
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

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LevelSelectionViewModel()
        LevelSelectionView(viewModel: viewModel)
    }
}
