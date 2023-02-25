//
//  GrayButton.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/26.
//

import Foundation
import SwiftUI

struct GrayButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    let minWidth: CGFloat
    let minHeight: CGFloat

    init(minWidth: CGFloat = .zero, minHeight: CGFloat = .zero) {
        self.minWidth = minWidth
        self.minHeight = minHeight
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: minWidth, minHeight: minHeight)
            .background(Color(hex: 0x707070))
            .border(width: 4, edges: [.top, .leading], color: isEnabled ? Color(hex: 0xa9a9a9) : Color(hex: 0x575757))
            .border(width: 4, edges: [.bottom, .trailing], color: isEnabled ? Color(hex: 0x575757) : Color(hex: 0xa9a9a9))
            .foregroundColor(.accentColor)
            .overlay(.black.opacity(isEnabled ? 0.0 : 0.5))
    }
}
