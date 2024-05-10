//
//  ContentView.swift
//  ContriesAPI
//
//  Created by Choudhary, Alok on 9/6/23.
//

import SwiftUI

struct CountriesListView: View {
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
                    List(array) { country in
                        NavigationLink(destination: CountryDetailView(country: country)) {
                            CountryCellView(country: country)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
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
    }
}
