//
//  CountryService.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 04/05/2024.
//

import Foundation 

protocol CountryServiceProtocol {
    func fetchAllCountries() async throws -> [CountryDetail]
    func searchCountriesByName(_ name: String) async throws -> [CountryDetail]
}

class CountryService: CountryServiceProtocol {
    private let baseURL = APIConstants.baseURL
    private let networkManager = NetworkManager.shared
    
    func fetchAllCountries() async throws -> [CountryDetail] {
        let str = "\(baseURL)/all"
        guard let url = URL(string: str) else {
            throw NetworkError.invalidURL
        }
        return try await networkManager.fetchData(from: url) as [CountryDetail]
    }
    
    func searchCountriesByName(_ name: String) async throws -> [CountryDetail] {
        let str = APIConstants.searchCountriesEndpoint + name
        guard let url = URL(string: str) else {
            throw NetworkError.invalidURL
        }
        return try await networkManager.fetchData(from: url) as [CountryDetail]
    }
}
