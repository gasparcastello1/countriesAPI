//
//  SavedCountriesListView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 10/05/2024.
//
import SwiftUI

struct SavedCountriesListView: View {
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
                            if CountriesUDManager
                                .shared
                                .countries
                                .contains(
                                    country.officialName
                                ) {
                                CountryCellView(country: country)
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        navigationHandler.navigate(to: .countryDetail(country: country))
                                    }
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
            .navigationTitle("Favs countries")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer, prompt: "type here to search")
        .onAppear {
            viewModel.fetchAllCountries()
        }
    }
}

struct SavedCountriesListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCountriesListView()
            .environmentObject(NavigationHandler())
    }
}
