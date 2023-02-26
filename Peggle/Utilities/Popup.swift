//  Adapted from https://www.vadimbulavin.com/swiftui-popup-sheet-popover/
//
//  Popup.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import SwiftUI

struct Popup<T: View>: ViewModifier {
    let popup: T
    let isPresented: Bool
    let alignment: Alignment

    init(isPresented: Bool, alignment: Alignment, @ViewBuilder content: () -> T) {
        self.isPresented = isPresented
        self.alignment = alignment
        popup = content()
    }

    func body(content: Content) -> some View {
        content
            .overlay(popupContent())
    }

    @ViewBuilder private func popupContent() -> some View {
        GeometryReader { geometry in
            popup
                .animation(Animation.spring(), value: isPresented)
                .offset(x: 0, y: isPresented ? 0 : geometry.belowScreenEdge)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: alignment)
                .background(.black.opacity(isPresented ? 0.5 : 0.0))
                .zIndex(Double.infinity)
        }
    }
}

extension GeometryProxy {
    var belowScreenEdge: CGFloat {
        UIScreen.main.bounds.height - frame(in: .global).minY
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    struct Preview: View {
        @State var isPresented = false

        var body: some View {
            ZStack {
                Color.clear
                VStack {
                    Button("Toggle", action: { isPresented.toggle() })
                    Spacer()
                }
            }
            .modifier(Popup(isPresented: isPresented,
                            alignment: .center,
                            content: { Color.blue.frame(width: 100, height: 100) }))
        }
    }
}
