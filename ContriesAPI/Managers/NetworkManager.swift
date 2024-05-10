//
//  NetworkManager.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 04/05/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case httpConnection(Error)

    // Localized description for each case
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .noData:
            return NSLocalizedString("No Data could be fectched", comment: "No Data")
        case .decodingError:
            return NSLocalizedString("Decoding Error", comment: "Decoding Error")
        case .httpConnection(let error):
            return error.localizedDescription
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        var data: Data
        
        if let cached = try await CacheManager.shared.getData(from: url) {
            data = cached
        } else {
            let (apiData, response) = try await URLSession.shared.data(from: url)
            data = apiData
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.httpConnection(NSError(domain: "", code: 0, userInfo: nil))
            }
            await CacheManager.shared.save(data, for: url)
        }
        return try parseData(data, to: T.self)
    }
    
    private func parseData<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print(error.localizedDescription,#line)
            throw NetworkError.decodingError
        }
    }
}

actor CacheManager {
    static let shared = CacheManager()
    private var cache = [URL: Data]()
    
    func getData(from url: URL) async throws -> Data? {
        cache[url]
    }
    
    func save(_ data: Data, for url: URL) async {
        if cache[url] == nil {
            cache[url] = data
        }
    }
}

