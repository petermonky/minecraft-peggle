//
//  ActionViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/27.
//

import Foundation

typealias ActionViewModel = ActionView.ViewModel

extension ActionView {
    class ViewModel: ObservableObject {
        @Published var title: String

        init(title: String = "") {
            self.title = title
        }

        var isValidForm: Bool {
            !title.isEmpty
        }

        func loadTitle(_ title: String) {
            self.title = title
        }

        func resetTitle() {
            title = ""
        }
    }
}
