//
//  LevelListViewModel.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/26.
//

import Foundation

typealias LevelListViewModel = LevelListView.ViewModel

extension LevelListView {
    class ViewModel: ObservableObject {
        @Published var levels: Set<Level>

        init(levels: Set<Level> = []) {
            self.levels = levels
        }

        var levelArray: [Level] {
            Array(levels).sorted(by: { $0.updatedAt.compare($1.updatedAt) == .orderedDescending })
        }

        func addLevel(_ level: Level) {
            levels.remove(level)
            levels.insert(level)
        }

        func deleteLevel(_ level: Level) {
            levels.remove(level)
        }

        func loadLevels(_ levels: Set<Level>) {
            DispatchQueue.main.async {
                self.levels = levels
            }
        }
    }
}
