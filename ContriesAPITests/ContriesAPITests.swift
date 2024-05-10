//
//  ContriesAPITests.swift
//  ContriesAPITests
//
//  Created by Choudhary, Alok on 9/6/23.
//

import XCTest
@testable import ContriesAPI
import Combine

class CountriesAPIUnitTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    
    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }
    
    // Mock CountryService
    class MockCountryService: CountryService {
        
        private var allCountries: [CountryDetail] = [CountryDetail.mocked, CountryDetail.mocked]
        private var searchedCountries: [CountryDetail] = [CountryDetail.mocked]
        private var error: NetworkError?
        
        init(error: NetworkError? = nil) {
            self.error = error
        }
        
        override func fetchAllCountries() async throws -> [CountryDetail] {
            if let error {
                throw error
            } else {
                return allCountries
            }
        }
        
        override func searchCountriesByName(_ name: String) async throws -> [CountryDetail] {
            if let error {
                throw error
            } else {
                return searchedCountries
            }
        }
    }

    func test_viewModelInitialState() {
        // given
        let mockService = MockCountryService()
        //when
        let viewModel = CountriesListViewModel(service: mockService)
        //then
        XCTAssertEqual(viewModel.state, .initial)
    }
    
    func test_searchCountriesSuccess() {
        // given
        let mockService = MockCountryService()
        let viewModel = CountriesListViewModel(service: mockService)
        let loaded = XCTestExpectation(description: "state is loaded with values")

        // when
        viewModel.searchTerm = "Argentina"
        viewModel.$state
            .sink(receiveValue: { state in
                if case .loaded(let array) = state, !array.isEmpty {
                    loaded.fulfill()
                    XCTAssertEqual(state, .loaded([CountryDetail.mocked]), "State should be loaded with non empty array")
                }
            })
            .store(in: &cancellables)

        // then
        wait(for: [loaded], timeout: 1.0, enforceOrder: true)
    }
    
    func test_searchCountriesAPIFailure() {
        // given
        let mockService = MockCountryService(error: NetworkError.noData)
        let viewModel = CountriesListViewModel(service: mockService)
        let error = XCTestExpectation(description: "state is error")
        
        // when
        viewModel.searchTerm = "Argentina"
        
        viewModel.$state
            .sink(receiveValue: { state in
                if case .error(NetworkError.noData) = state {
                    error.fulfill()
                    XCTAssertEqual(state, .error(NetworkError.noData), "State should be error with no data")
                }
            })
            .store(in: &cancellables)

        // then
        wait(for: [error], timeout: 1.0, enforceOrder: true)
    }
}
