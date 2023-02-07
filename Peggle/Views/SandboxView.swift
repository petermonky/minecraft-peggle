//
//  SandboxView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/05.
//

import SwiftUI

struct SandboxView: View {
    @StateObject var renderer: Renderer

    init(renderer: Renderer = .init()) {
        _renderer = StateObject(wrappedValue: renderer)
    }

    var body: some View {
        ZStack {
//            renderer.ballGameView

            ForEach(renderer.ballGameViews, id: \.position) { $0 }

            ForEach(renderer.pegGameViews, id: \.position) { $0 }
        }
    }
}

struct SandboxView_Previews: PreviewProvider {
    static var previews: some View {
        SandboxView()
    }
}
