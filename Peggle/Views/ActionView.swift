//
//  ActionView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/23.
//

import SwiftUI

struct ActionView: View {
    @EnvironmentObject var levelDesigner: LevelDesignerView.ViewModel

    var body: some View {
        HStack {
            Button(action: {
                // action for button 1
            }) {
                Text("Button 1")
            }
            Button(action: {
                // action for button 2
            }) {
                Text("Button 2")
            }
            Button(action: {
                // action for button 3
            }) {
                Text("Button 3")
            }
            Button(action: {
                // action for button 4
            }) {
                Text("Button 4")
            }
        }
    }
}

struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        ActionView()
            .environmentObject(LevelDesignerView.ViewModel())
    }
}
