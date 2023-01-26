//
//  PersistenceStore.swift
//  Peggle
//
//  Created by Peter Jung on 2023/01/24.
//

import Foundation

class PersistenceController {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("levels.data")
    }

    static func load() async throws -> [Level] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case.success(let levels):
                    continuation.resume(returning: levels)
                }
            }
        }
    }

    static func load(completion: @escaping (Result<[Level], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let levels = try JSONDecoder().decode([Level].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(levels))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    @discardableResult
    static func save(levels: [Level]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(levels: levels) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case.success(let levelsSaved):
                    continuation.resume(returning: levelsSaved)
                }
            }
        }
    }

    static func save(levels: [Level], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(levels)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(levels.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
