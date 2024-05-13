//
//  NavigationHandler.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 10/05/2024.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case countryList
    case countryDetail(country: CountryDetail)
}

final class NavigationHandler: ObservableObject {
    
    @Published var path: NavigationPath = .init()

    func navigate(to navigationDestination: NavigationDestination) {
        path.append(navigationDestination)
    }
}
