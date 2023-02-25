//
//  BackButtonView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/26.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: { dismiss() }) {
            HStack {
                Image(systemName: "arrow.backward").font(.system(size: 12, weight: .bold))
                Text("Back").font(.custom("Minecraft-Regular", size: 20))
            }
        }
        .zIndex(.infinity)
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView()
    }
}
