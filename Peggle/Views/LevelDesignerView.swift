//
//  LevelDesignerView.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/19.
//

import SwiftUI

struct LevelDesignerView: View {
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            BoardView(viewModel: viewModel.boardViewModel)
            PaletteView(viewModel: viewModel.paletteViewModel)
        }
        .ignoresSafeArea()
        .environmentObject(viewModel)
    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        return LevelDesignerView()
    }
}
