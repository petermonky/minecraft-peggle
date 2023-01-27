//
//  View+IsRendered.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/27.
//

import Foundation
import SwiftUI

extension View {
    func isRendered(_ bool: Bool) -> some View {
        modifier(EmptyModifier(isRendered: bool))
    }
}

struct EmptyModifier: ViewModifier {
    let isRendered: Bool

    func body(content: Content) -> some View {
        Group {
            if isRendered {
                content
            } else {
                EmptyView()
            }
        }
    }
}
