//
//  LevelSelectionViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/02/23.
//

import Foundation

@MainActor class LevelSelectionViewModel: ObservableObject {
    @Published private(set) var levels: [Level] = []
    private let dataManager = DataManager()

    func loadData() async throws {
        levels = try await dataManager.load()
    }
}
