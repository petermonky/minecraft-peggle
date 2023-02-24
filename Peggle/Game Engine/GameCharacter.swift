//
//  GameCharacter.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

protocol GameCharacter: AnyObject {
    var name: String { get }

    func applyPower(gameEngine: GameEngine)
}
