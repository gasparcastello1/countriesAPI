//
//  CountryCellView.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 05/05/2024.
//

import SwiftUI

struct CountryCellView: View {
    let country: CountryDetail
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 8, content: {
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
        })
        .padding(16)
        .frame(height: 100)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.15),
                        radius: CGFloat(2),
                        x: 0,
                        y: 2)
        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 4)
        
    }
}
struct CountryCellView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCellView(country: CountryDetail.mocked)
    }
}
