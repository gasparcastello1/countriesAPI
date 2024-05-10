//
//  CountiesListViewModel.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 04/05/2024.
//

import Foundation
import Combine

protocol CountriesListViewModelProtocol: ObservableObject {
    var state: ViewModelState { get }
    var searchTerm: String { get set }
    
    func fetchAllCountries()
    func searchCountries(byName name: String)
}

enum ViewModelState: Equatable {
    static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let lhsCountries), .loaded(let rhsCountries)):
            return lhsCountries == rhsCountries
        case (.error(let lhsError), .error(let rhsError)):
            return "\(lhsError)" == "\(rhsError)"
        default:
            return false
        }
    }
    
    case initial
    case loading
    case loaded([CountryDetail])
    case error(Error)
}

class CountriesListViewModel: CountriesListViewModelProtocol {
    
    @Published var state: ViewModelState
    @Published var searchTerm: String
    private var cancellables: Set<AnyCancellable> = []
    
    private var searchTask: Task<Void, Never>?
    private let service: CountryServiceProtocol
    
    private var allCountries: [CountryDetail]
    private var searchedCountries: [CountryDetail]
        
    init(state: ViewModelState = .initial,
         searchTerm: String = "",
         searchTask: Task<Void, Never>? = nil,
         allCountries: [CountryDetail] = [],
         service: CountryServiceProtocol = CountryService(),
         searchedCountries: [CountryDetail] = []) {
        self.state = state
        self.searchTerm = searchTerm
        self.searchTask = searchTask
        self.allCountries = allCountries
        self.service = service
        self.searchedCountries = searchedCountries
        $searchTerm
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] searchTerm in
                guard let self else { return }
                self.searchCountries(byName: searchTerm)
            }
            .store(in: &cancellables)
    }

    func fetchAllCountries() {
        Task { @MainActor in
            do {
                state = .loading
                let fetchedCountries = try await service.fetchAllCountries()
                allCountries = fetchedCountries
                state = .loaded(fetchedCountries)
            } catch {
                state = .error(NetworkError.noData)
            }
        }
    }
    
    func searchCountries(byName name: String) {
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            do {
                guard !name.isEmpty else {
                    state = .loaded(allCountries)
                    return
                }
                state = .loading
                self.searchedCountries = []
                let searchedCountries = try await self.service.searchCountriesByName(name)
                self.searchedCountries = searchedCountries
                state = .loaded(searchedCountries)
            } catch {
                state = .error(NetworkError.noData)
            }
        }
    }
    
    func onSaveTap(country: Country) {
        if isSaved {
            UserDefaults.standard.delete(country: country)
        } else {
            UserDefaults.standard.save(country: country)
        }
    }
    
}
