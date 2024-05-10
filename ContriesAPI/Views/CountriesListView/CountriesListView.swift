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
//                    CountriesLoadedView(countries: array)
                    NavigationStack(path: $navigationHandler.path) {
                        List(array) { country in
                                CountryCellView(country: country)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    navigationHandler.navigate(to: .countryDetail(country: country))
                                }
//                            }
                            
                        }
                        .listStyle(.plain)
                        .navigationDestination(for: NavigationDestination.self) { destination in
                            switch destination {
                            case .countryList:
                                CountriesListView()
                            case .countryDetail(let country):
                                CountryDetailView(country: country, viewModel: viewModel)
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
