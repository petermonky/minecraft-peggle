//
//  PaletteView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import SwiftUI

struct PaletteView: View {
    @StateObject var viewModel: ViewModel

    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            ForEach(viewModel.pegButtons.indices, id: \.self) { index in
                let pegButton = viewModel.pegButtons[index]
                Button(action: {
                    viewModel.onPegButtonSelect(pegButton: pegButton)
                }) {
                    Image(pegButton.imageName)
                        .resizable()
                        .frame(width: 160, height: 160)
                        .overlay(Color.white.opacity(viewModel.mode == pegButton.type ? 0.5 : 0.0))
                        .clipShape(Circle())
                }.padding()
            }
            
            Spacer()
            
            let deleteButton = viewModel.deleteButton
            Button(action: {
                viewModel.onDeleteButtonSelect()
            }) {
                Image(deleteButton.imageName)
                    .resizable()
                    .frame(width: 160, height: 160)
                    .overlay(Color.white.opacity(viewModel.mode == deleteButton.type ? 0.5 : 0.0))
                    .clipShape(Circle())
            }.padding()
        }
        .background(Color.white)
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView()
    }
}

