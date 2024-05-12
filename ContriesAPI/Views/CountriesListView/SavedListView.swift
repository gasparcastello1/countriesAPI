//
//  SavedListView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 11/05/2024.
//

import SwiftUI

struct SavedListView: View {
    @EnvironmentObject private var navigationHandler: NavigationHandler
    @StateObject var viewModel = CountriesListViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .initial:
                    Text("initial state")
                case .loading:
                    ProgressView()
                case .loaded(let array):
                    NavigationStack(path: $navigationHandler.path) {
                        List(array) { country in
                            if viewModel.isFav(country) {
                                CountryCellView(viewModel: viewModel, country: country)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            if case .countryDetail(let country) = destination {
                                CountryDetailView(viewModel: viewModel, country: country)
                            }
                        }
                    }
                case .error(let error):
                    VStack {
                        Text("\(error.localizedDescription)")
                    }
                }
                Spacer()
            }
            .navigationTitle("Countries")
            .navigationBarTitleDisplayMode(.inline)
        }
//        .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer, prompt: "type here to search")
        .onAppear {
            navigationHandler.path = .init()
            viewModel.fetchAllCountries()
        }
    }
}

struct SavedListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedListView()
            .environmentObject(NavigationHandler())
    }
}
