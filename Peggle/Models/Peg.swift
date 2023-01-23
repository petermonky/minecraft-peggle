//
//  Peg.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/22.
//

import Foundation
import SwiftUI

class Peg: Hashable, Identifiable {
    var id = UUID()
    var imageName: String
    var position: CGPoint
    
    init(imageName: String, position: CGPoint) {
        self.imageName = imageName
        self.position = position
    }
    
    func overlapsWith(peg: Peg) -> Bool {
        return self.position.distance(to: peg.position) <= 2 * Constants.Peg.radius
    }
    
    func translateBy(_ value: CGSize) {
        position.x += value.width
        position.y += value.height
    }
    
    func clone() -> Peg {
        Peg(imageName: imageName, position: position)
    }
    
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class BluePeg: Peg {
    init(position: CGPoint = CGPointZero) {
        super.init(imageName: "peg-blue", position: position)
    }
}

class OrangePeg: Peg {
    init(position: CGPoint = CGPointZero) {
        super.init(imageName: "peg-orange", position: position)
    }
}
