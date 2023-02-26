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

    private func renderData() -> some View {
        HStack(spacing: 16) {
            if let time = viewModel.gameEngine.time {
                renderImageAndText(imageName: "clock", text: String(format: "%.1f", time), textWidth: 60)
            }
            if let lives = viewModel.gameEngine.lives {
                renderImageAndText(imageName: "heart", text: String(lives), textWidth: 40)
            }
            if let bucketShotCount = viewModel.gameEngine.bucketShotCount {
                renderImageAndText(imageName: "bucket", text: String(bucketShotCount), textWidth: 40)
            }
            renderImageAndText(
                imageName: "peg-blue",
                text: String(viewModel.gameEngine.bluePegsCount),
                textWidth: 40
            )
            renderImageAndText(
                imageName: "peg-red",
                text: String(viewModel.gameEngine.redPegsCount),
                textWidth: 40
            )
            renderImageAndText(
                imageName: "peg-green",
                text: String(viewModel.gameEngine.greenPegsCount),
                textWidth: 40
            )
        }
    }

    private func renderImageAndText(imageName: String, text: String, textWidth: CGFloat) -> some View {
        HStack(spacing: 16) {
            Image(imageName).resizable().scaledToFit().frame(width: 40, height: 40)
            Text(text)
                .font(.custom("Minecraft-Regular", size: 20))
                .frame(width: textWidth, alignment: .leading)
        }
    }

    private func renderScore() -> some View {
        HStack(spacing: 8) {
            Text("Score:")
                .font(.custom("Minecraft-Regular", size: 20)).bold()
            Text("\(viewModel.gameEngine.score)")
                .font(.custom("Minecraft-Regular", size: 20))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                if !viewModel.gameEngine.isInState(.loading) {
                    renderData()
                    renderScore()
                    if let goalText = viewModel.gameEngine.mode?.goalText {
                        Text("\(goalText)")
                            .font(.custom("Minecraft-Regular", size: 16))
                    }
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color(hex: 0x91bff1))
            RendererView(renderer: viewModel.renderer)
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
