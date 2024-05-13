//
//  CountryDetailView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 04/05/2024.
//

import SwiftUI

struct CountryDetailView: View {
    
    private enum CountryPropRow: String, CaseIterable, Identifiable {
        case coatOfArms = "Coat of Arms"
        case region = "Region"
        case subregion = "Subregion"
        case capital = "Capital"
        case area = "Area"
        case population = "Population"
        case languages = "Languages"
        case carDriverSide = "Car driver side"
        case currencies = "Currencies"
        case timezones = "Time zones"
        
        var id: String { rawValue }
    }
    
    @ObservedObject var viewModel: CountriesListViewModel
    private var isSaved: Bool {
        viewModel.favCountries.contains(country.officialName)
    }
    let country: CountryDetail
    
    private var languages: String? {
        country.languages?
            .values.map { $0 }
            .joined(separator: ", ")
    }
    
    private var currencies: String? {
        country.currencies?
            .map { key, value in
                "\(key) - (\(value.name ?? ""))"
            }
            .joined(separator: ", ")
    }
    
    private var population: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: country.population ?? 0)) ?? ""
    }
    
    private var timezones: String {
        country.timezones?
            .map { $0 }
            .joined(separator: ", ") ?? ""
    }
    
    @ViewBuilder
    private var header: some View {
        AsyncImage(url: URL(string: country.flagURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        
        .frame(width: 120, alignment: .leading)
        .clipShape(.rect(cornerRadius: 4))
    }

    @ViewBuilder
    private var title: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text(country.commonName)
                .setTitle()
            Text(country.officialName)
                .setSubtitle()
                .foregroundStyle(.gray)
        })
    }

    @ViewBuilder
    private var content: some View {
        HStack(alignment: .top, spacing: 16, content: {
            VStack(alignment: .leading, spacing: 24) {
                CountryCellField(type: .image(title: CountryPropRow.coatOfArms.rawValue, imagePath: country.coatOfArmsURL ?? ""))
                CountryCellField(type: .plainText(title: CountryPropRow.region.rawValue, description: country.region ?? ""))
                CountryCellField(type: .plainText(title: CountryPropRow.subregion.rawValue, description: country.subregion ?? ""))
                CountryCellField(type: .plainText(title: CountryPropRow.capital.rawValue, description: country.capital ?? ""))
                CountryCellField(type: .plainText(title: CountryPropRow.area.rawValue, description: String(country.area ?? 0)))
//                Spacer()
            }
            Spacer()
            VStack(alignment: .leading, spacing: 24) {
                CountryCellField(type: .plainText(title: CountryPropRow.population.rawValue, description: population))
                CountryCellField(type: .plainText(title: CountryPropRow.languages.rawValue, description: languages ?? ""))
                CountryCellField(type: .icons(title: CountryPropRow.carDriverSide.rawValue, side: country.carDriverSide))
                CountryCellField(type: .plainText(title: CountryPropRow.currencies.rawValue, description: currencies ?? ""))
                CountryCellField(type: .plainText(title: CountryPropRow.timezones.rawValue, description: timezones))
//                Spacer()
            }
        })
    }

    var body: some View {
        HStack(alignment: .center, content: {
            VStack(alignment: .leading, spacing: 24, content: {
                header
                title
                content
                Spacer()
            })
            .padding(.horizontal, 12)
            .padding(.top, 24)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(country.commonName)
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    topBarTrailingItem()
                }
            }
            Spacer()
        })
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func topBarTrailingItem() -> some View {
        Button(action: {
            viewModel.onBookmarkToggle(country)
        }, label: {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
        })
    }
}

#Preview {
    CountryDetailView(viewModel: CountriesListViewModel(), country: CountryDetail.mocked)
}
