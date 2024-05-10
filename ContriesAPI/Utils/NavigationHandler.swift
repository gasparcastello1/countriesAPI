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
    
    @Published var path = NavigationPath()

    func navigate(to navigationDestination: NavigationDestination) {
        path.append(navigationDestination)
    }
}

extension View {
//    func withNavigationDestinations() -> some View {
//        self.navigationDestination(for: NavigationDestination.self) { destination in
//            switch destination {
//            case .countryList:
//                CountriesListView()
//            case .countryDetail(let country):
//                CountryDetailView(country: country)
//            }
//        }
//    }
}
