//
//  CountriesLoadedView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 10/05/2024.
//

import SwiftUI

struct CountriesLoadedView: View {
    @EnvironmentObject private var navigationHandler: NavigationHandler
    let countries: [CountryDetail]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(countries, id: \.id) { country in
                CountryCellView(country: country)
                .onTapGesture {
                    navigationHandler
                        .navigate(
                            to: .countryDetail(
                                country: country
                            )
                        )
                }
            }
        }
    }
}

#Preview {
    CountriesLoadedView(
        countries:
            [
                CountryDetail.mocked,
                CountryDetail.mocked
            ]
    )
}
