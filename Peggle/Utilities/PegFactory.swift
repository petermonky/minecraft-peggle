//
//  PegFactory.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import Foundation

protocol PegFactory {
    func createPegAtPosition(_: CGPoint) -> Peg
}

class BluePegFactory: PegFactory {
    func createPegAtPosition(_ position: CGPoint) -> Peg {
        BluePeg(position: position)
    }
}

class RedPegFactory: PegFactory {
    func createPegAtPosition(_ position: CGPoint) -> Peg {
        RedPeg(position: position)
    }
}

class GreenPegFactory: PegFactory {
    func createPegAtPosition(_ position: CGPoint) -> Peg {
        GreenPeg(position: position)
    }
}
