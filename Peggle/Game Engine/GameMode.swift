//
//  GameMode.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/24.
//

import Foundation

protocol GameMode: AnyObject {
    var gameEngine: GameEngine? { get set }
    var presetDuration: Double? { get }
    var presetLives: Int? { get }
    var goalText: String { get }

    func handleGameOver()
}
