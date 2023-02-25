//
//  NavigationLazyView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/25.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
