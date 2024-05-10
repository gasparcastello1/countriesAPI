//
//  SavedCountriesListView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 10/05/2024.
//
import SwiftUI
import Combine

class SavedCountriesListViewModel: ObservableObject {
    
    @Published var countries = [CountryDetail]()
    @Published var showEmptyState = true
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    init() {
        setupSavedCountriesBinding()
    }
    
    // MARK: - BINDING METHODS
    
    private func setupSavedCountriesBinding() {
//        UserDefaults.standard
//            .publisher(for: \.savedCountriesCount)
//            .handleEvents(receiveOutput: { [weak self] count in
//                guard let self else {
//                    return
//                }
//                
//               countries = UserDefaults.standard.getCountries() ?? []
//            })
//            .sink { [weak self] count in
//                guard let self else {
//                    return
//                }
//                
//                self.showEmptyState = count == 0
//            }
//            .store(in: &cancellables)
    }
}



struct SavedCountriesListView: View {
    
//    @EnvironmentObject private var navigationState: NavigationState
    @StateObject private var viewModel: SavedCountriesListViewModel = .init()

    var body: some View {
//        NavigationStack(path: $navigationState.path) {
//            NavigationView(content: {
//                contentView()
//                    .emptyStateView(type: .emptySaved,
//                                    isPresented: $viewModel.showEmptyState)
//                    .navigationTitle("Saved")
//                    .navigationBarTitleDisplayMode(.inline)
//            })
//            .navigationViewStyle(.stack)
////            .withNavigationDestinations()
//        }
//    }
//    
//    @ViewBuilder
//    private func contentView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.countries, id: \.id) { item in
                    CountryCellView(country: item)
                        .onTapGesture {
//                            navigationState.navigate(to: .countryDetail(country: item))
                        }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    SavedCountriesListView()
}
