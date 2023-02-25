//
//  DataView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/22.
//

import SwiftUI

struct DataView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerViewModel

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 16) {
                Image("peg-blue").resizable().scaledToFit().frame(width: 40, height: 40)
                Text("\(levelDesigner.bluePegObjectsCount)")
                    .frame(width: 40, alignment: .leading)
            }
            HStack(spacing: 16) {
                Image("peg-orange").resizable().scaledToFit().frame(width: 40, height: 40)
                Text("\(levelDesigner.orangePegObjectsCount)")
                    .frame(width: 40, alignment: .leading)
            }
            HStack(spacing: 16) {
                Image("peg-green").resizable().scaledToFit().frame(width: 40, height: 40)
                Text("\(levelDesigner.greenPegObjectsCount)")
                    .frame(width: 40, alignment: .leading)
            }
            HStack(spacing: 16) {
                Image("block").resizable().scaledToFit().frame(width: 40, height: 40)
                Text("\(levelDesigner.blockObjectsCount)")
                    .frame(width: 40, alignment: .leading)
            }
        }
        .font(.custom("Minecraft-Regular", size: 20))
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(
            Image("background-dirt")
                .resizable(resizingMode: .tile)
        )
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
