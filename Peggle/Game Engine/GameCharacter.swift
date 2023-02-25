//
//  GameCharacter.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

protocol GameCharacter: AnyObject {
    var gameEngine: GameEngine? { get set }
    var name: String { get }
    var description: String { get }

    func applyPower()
}
