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
        HStack {
        }
        .frame(height: 80)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
