//
//  GamePlayerViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/21.
//

import Foundation
import Combine

@MainActor class GamePlayerViewModel: ObservableObject {
    let gameEngine: GameEngine
    let renderer: Renderer
    var anyCancellable: AnyCancellable?

    init(level: Level) {
        self.renderer = Renderer()
        self.gameEngine = GameEngine(level: level, renderer: renderer)
        anyCancellable = gameEngine.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}
