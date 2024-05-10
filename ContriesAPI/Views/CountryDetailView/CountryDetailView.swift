//
//  CountryDetailView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 04/05/2024.
//

import SwiftUI

struct CountryDetailView: View {
    
    private enum CountryPropRow: String, CaseIterable, Identifiable {
        case capital = "Capital"
        case region = "Region"
        case subregion = "Subregion"
        case languages = "Languages"
        case currencies = "Currencies"
        case population = "Population"
        case carDriverSide = "Car driver side"
        case coatOfArms = "Coat of Arms"
        
        var id: String { rawValue }
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
    
    @ViewBuilder
    private var countryPropRow: some View {
        ForEach(CountryPropRow.allCases, id: \.id) { prop in
            switch prop {
            case .capital:
                CountryCellField(tuple: (prop.rawValue, country.capital))
            case .region:
                CountryCellField(tuple: (prop.rawValue, country.region ?? ""))
            case .subregion:
                CountryCellField(tuple: (prop.rawValue, country.subregion ?? ""))
            case .languages:
                CountryCellField(tuple: (prop.rawValue, languages ?? ""))
            case .currencies:
                CountryCellField(tuple: (prop.rawValue, currencies ?? ""))
            case .population:
                CountryCellField(tuple: (prop.rawValue, population))
            case .carDriverSide:
                CountryCellField(tuple: (prop.rawValue, country.carDriverSide ?? ""))
            case .coatOfArms:
                CountryCellField(tuple: (prop.rawValue, ""))
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16, content: {
            //Image
            HStack {
                AsyncImage(url: URL(string: country.flagURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                
                .frame(width: 120, alignment: .center)
                .clipShape(.rect(cornerRadius: 4))
                Spacer()
            }
            //Title
            HStack {
                Text(country.commonName)
                    .setTitle()
                Text(country.officialName)
                    .setContent()
                    .foregroundStyle(.gray)
                Spacer()
            }
            
            //Prop Rows
            countryPropRow
            
            //Coat of arms
            if let coatOfArmsURL = country.coatOfArmsURL {
                HStack {
                AsyncImage(url: URL(string: coatOfArmsURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, alignment: .leading)
                    Spacer()
                }
            }
            Spacer()
        })
        .padding(.horizontal, 12)
        .padding(.top, 24)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(country.commonName)
                    .font(.headline)
            }
        }
    }
    
}
