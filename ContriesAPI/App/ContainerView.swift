//
//  ContainerView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 10/05/2024.
//

import SwiftUI

struct ContainerView: View {
    
    @StateObject private var listNavigationHandler = NavigationHandler()
    @StateObject private var savedNavigationHandler = NavigationHandler()

    var body: some View {
        TabView {
            CountriesListView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .environmentObject(listNavigationHandler)
            SavedCountriesListView()
                .tabItem {
                    Label("Favourites", systemImage: "star")
                }
                .environmentObject(savedNavigationHandler)
        }
    }
}

#Preview {
    ContainerView()
}
