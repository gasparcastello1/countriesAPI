//
//  UserDefaultsHelper.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 10/05/2024.
//
import Foundation
import Combine

class CountriesUDManager: ObservableObject {
    static let shared = CountriesUDManager()

    private enum UDKey: String {
        case savedCountries
    }

    private let userDefaults = Foundation.UserDefaults.standard

    @Published var countriesPublisher: [String] = []
    
    var countries: [String] {
        get {
            userDefaults.array(forKey: UDKey.savedCountries.rawValue) as? [String] ?? []
        }
        set {
            userDefaults.setValue(newValue, forKey: UDKey.savedCountries.rawValue)
        }
    }
    
    func save(country: String) {
        if countries.contains(country) {
            return
        }
        countries = countries + [country]
        countriesPublisher = countries
    }
    
    func delete(country: String) {
        if !countries.contains(country) {
            return
        }
        countries = countries.filter { $0 != country }
        countriesPublisher = countries
    }
}
