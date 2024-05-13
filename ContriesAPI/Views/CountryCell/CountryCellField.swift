//
//  CountryCellField.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 05/05/2024.
//

import SwiftUI

enum PropFieldType {
    case plainText(title: String, description: String)
    case image(title: String, imagePath: String)
    case icons(title: String, side: Side?)
    
    var title: String {
        switch self {
        case .plainText(let title, let description):
            title
        case .image(let title, let imagePath):
            title
        case .icons(let title, let side):
            title
        }
    }
}

struct CountryCellField: View {
    
    let type: PropFieldType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(type.title)
                .setSubtitle()
            switch type {
            case let .plainText(title, description):
                plainView(title, description: description)
            case let .image(title, imagePath):
                imageView(title, imagePath: imagePath)
            case let .icons(title, side):
                carSideView(title, side: side)
            }
        }
    }
    
    @ViewBuilder
    private func plainView(_ title: String, description: String) -> some View {
            Text(description)
                .font(.body)
                .foregroundStyle(.gray)
    }
    
    @ViewBuilder
    private func imageView(_ title: String, imagePath: String) -> some View {
        AsyncImage(url: URL(string: imagePath)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 75, height: 75, alignment: .leading)
    }
    
    @ViewBuilder
    private func carSideView(_ title: String, side: Side? = nil) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(title)
//                .font(.subheadline)
            if let side = side {
                HStack(spacing: 8) {
                    sideImageView(side: .left, isSelected: side == .left)
                    sideImageView(side: .right, isSelected: side == .right)
                }
            }
//        }
    }
    
    @ViewBuilder
    private func sideImageView(side: Side, isSelected: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "car.circle")
            Text(side.rawValue)
                .textCase(.uppercase)
                .font(.footnote)
        }
        .foregroundStyle(.gray)
        .opacity(isSelected ? 1 : 0.25)
    }
}

#Preview {
    HStack {
        VStack(alignment: .leading,spacing: 100.0, content: {
            CountryCellField(type: .icons(title: "Car Side", side: .left))
            CountryCellField(type: .image(title: "Coat of arms", imagePath: "https://mainfacts.com/media/images/coats_of_arms/lv.png"))
            CountryCellField(type: .plainText(title: "Currencies", description: "pesitos"))
        })
        Spacer()
    }
}
