//
//  APIConstants.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 04/05/2024.
//

import Foundation

struct APIConstants {
    static let baseURL: String = "https://restcountries.com/v3.1"
    static let allCountriesEndpoint: String = "\(baseURL)/all"
    static let searchCountriesEndpoint: String = "\(baseURL)/name/"
}
