//
//  ContentView.swift
//  ContriesAPI
//
//  Created by Choudhary, Alok on 9/6/23.
//

import SwiftUI

struct CountriesListView: View {
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
                        List(array.sorted(by: { $0.officialName < $1.officialName } )) { country in
                            CountryCellView(viewModel: viewModel, country: country)
                                .listRowSeparator(.hidden)
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
        .searchable(text: $viewModel.searchTerm, placement: .navigationBarDrawer, prompt: "type here to search")
        .onAppear {
            navigationHandler.path = .init()
            viewModel.fetchAllCountries()
        }
    }
}

struct CountriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesListView()
            .environmentObject(NavigationHandler())
    }
}
