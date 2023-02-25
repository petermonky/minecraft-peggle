//
//  GamePlayerView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

 import SwiftUI

 struct GamePlayerView: View {
    @StateObject var viewModel: GamePlayerViewModel

    init(viewModel: GamePlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                if !viewModel.gameEngine.isInState(.loading) {
                    HStack(spacing: 16) {
                        if let time = viewModel.gameEngine.time {
                            HStack(spacing: 16) {
                                Image("clock").resizable().scaledToFit().frame(width: 40, height: 40)
                                Text(String(format: "%.1f", time))
                                    .font(.custom("Minecraft-Regular", size: 20))
                                    .frame(width: 60, alignment: .leading)
                            }
                        }
                        if let lives = viewModel.gameEngine.lives {
                            HStack(spacing: 16) {
                                Image("heart").resizable().scaledToFit().frame(width: 40, height: 40)
                                Text("\(lives)")
                                    .font(.custom("Minecraft-Regular", size: 20))
                                    .frame(width: 40, alignment: .leading)
                            }
                        }
                        if let bucketShotCount = viewModel.gameEngine.bucketShotCount {
                            HStack(spacing: 16) {
                                Image("bucket").resizable().scaledToFit().frame(width: 40, height: 40)
                                Text("\(bucketShotCount)")
                                    .font(.custom("Minecraft-Regular", size: 20))
                                    .frame(width: 40, alignment: .leading)
                            }
                        }
                        HStack(spacing: 16) {
                            Image("peg-blue").resizable().scaledToFit().frame(width: 40, height: 40)
                            Text("\(viewModel.gameEngine.bluePegsCount)")
                                .font(.custom("Minecraft-Regular", size: 20))
                                .frame(width: 40, alignment: .leading)
                        }
                        HStack(spacing: 16) {
                            Image("peg-orange").resizable().scaledToFit().frame(width: 40, height: 40)
                            Text("\(viewModel.gameEngine.orangePegsCount)")
                                .font(.custom("Minecraft-Regular", size: 20))
                                .frame(width: 40, alignment: .leading)
                        }
                        HStack(spacing: 16) {
                            Image("peg-green").resizable().scaledToFit().frame(width: 40, height: 40)
                            Text("\(viewModel.gameEngine.greenPegsCount)")
                                .font(.custom("Minecraft-Regular", size: 20))
                                .frame(width: 40, alignment: .leading)
                        }
                    }
                    HStack(spacing: 8) {
                        Text("Score:")
                            .font(.custom("Minecraft-Regular", size: 20)).bold()
                        Text("\(viewModel.gameEngine.score)")
                            .font(.custom("Minecraft-Regular", size: 20))
                    }
                    if let goalText = viewModel.gameEngine.mode?.goalText {
                        Text("\(goalText)")
                            .font(.custom("Minecraft-Regular", size: 16))
                    }
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color(hex: 0x91bff1))
            GeometryReader { geometry in
                RendererView(gameEngine: viewModel.gameEngine)
                    .onAppear {
                        viewModel.gameEngine.initialiseLevel(frame: Frame(size: geometry.size))
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView())
        .ignoresSafeArea(.all)
        .modifier(Popup(isPresented: viewModel.gameEngine.isInState(.loading),
                        alignment: .center,
                        content: { GamePresetModalView().environmentObject(viewModel.gameEngine) }))
        .modifier(Popup(isPresented: viewModel.gameEngine.isGameOver,
                        alignment: .center,
                        content: { GameOverModalView().environmentObject(viewModel.gameEngine) }))
    }

 }

 struct GamePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GamePlayerViewModel(level: Level.mockData)
        GamePlayerView(viewModel: viewModel)
    }
 }
