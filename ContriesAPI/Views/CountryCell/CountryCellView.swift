//
//  CountryCellView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 05/05/2024.
//

import SwiftUI
import Combine

struct CountryCellView: View {
    @EnvironmentObject private var navigationHandler: NavigationHandler
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: CountriesListViewModel
    let country: CountryDetail
    private var isSaved: Bool { viewModel.isFav(country) }
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 8, content: {
            AsyncImage(url: URL(string: country.flagURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, alignment: .center)
            .clipShape(.rect(cornerRadius: 4))
            
            VStack(alignment: .leading, content: {
                Text(country.commonName)
                    .font(.headline)
                Text(country.officialName)
                    .font(.subheadline)
                Text(country.capital)
                    .font(.footnote)
            })
            Spacer()
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .foregroundStyle(colorScheme == .light ? .blue : .white)
        })
        .padding(16)
        .frame(height: 100)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .light ? .white : .gray)
                .shadow(color: Color.black.opacity(0.15),
                        radius: CGFloat(2),
                        x: 0,
                        y: 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .onTapGesture {
            navigationHandler.navigate(to: .countryDetail(country: country))
        }
        
    }
}

#Preview {
    VStack(content: {
        let viewModel = CountriesListViewModel.mocked
        CountryCellView(viewModel: viewModel, country: CountryDetail.mocked)
        
        CountryCellView(viewModel: CountriesListViewModel(), country: CountryDetail.mocked)
    })
}
//struct CountryCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = CountriesListViewModel.mocked
//        CountryCellView(viewModel: viewModel, country: CountryDetail.mocked)
//    }
//}
