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
    var searchTerm: String { get }
    var favCountries: [String] { get }
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
    @Published var favCountries: [String]
//    @ObservedObject var countriesUDManager: CountriesUDManager
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var searchTask: Task<Void, Never>?
    private let service: CountryServiceProtocol
    
    private var allCountries: [CountryDetail]
    private var searchedCountries: [CountryDetail]
    private var UDManager = CountriesUDManager.shared
    
    fileprivate func bindToPublished() {
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
        UDManager.$countriesPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] array in
                guard let self else { return }
                if array != self.favCountries {
                    self.favCountries = array
                }
            }
            .store(in: &cancellables)
    }
    
    init(state: ViewModelState = .initial,
         searchTerm: String = "",
         favCountries: [String] = CountriesUDManager.shared.countries,
         searchTask: Task<Void, Never>? = nil,
         allCountries: [CountryDetail] = [],
         service: CountryServiceProtocol = CountryService(),
         searchedCountries: [CountryDetail] = []) {
        self.state = state
        self.searchTerm = searchTerm
        self.favCountries = favCountries
        self.searchTask = searchTask
        self.allCountries = allCountries
        self.service = service
        self.searchedCountries = searchedCountries
        bindToPublished()
    }

    func fetchAllCountries() {
        Task { @MainActor in
            do {
                state = .loading
                let fetchedCountries = try await service.fetchAllCountries()
                allCountries = fetchedCountries
                state = .loaded(allCountries)
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
    
    func isFav(_ country: CountryDetail) -> Bool {
        favCountries.contains(country.officialName)
    }
    
    func onBookmarkToggle(_ country: CountryDetail) {
        isFav(country) ? deleteFromFavs(country) : saveOnFavs(country)
    }

    func saveOnFavs(_ country: CountryDetail) {
        favCountries.append(country.officialName)
        UDManager.save(country: country.officialName)
    }

    func deleteFromFavs(_ country: CountryDetail) {
        favCountries.removeAll(where: { name in
            name == country.officialName
        })
        UDManager.delete(country: country.officialName)
    }
}

#if DEBUG
extension CountriesListViewModel {
    static var mocked: CountriesListViewModel {
        let countryMocked = CountryDetail.mocked
        return CountriesListViewModel(favCountries: [countryMocked.officialName])
    }
}
#endif
