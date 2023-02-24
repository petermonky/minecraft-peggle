//
//  GameEngineDelegate.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import Foundation

protocol GameEngineDelegate: AnyObject {
    func didUpdateWorld()
    func didUpdateGameState()
}
