//
//  CountryCellField.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 05/05/2024.
//

import SwiftUI

struct CountryCellField: View {
    let tuple: (String, String)
    
    var body: some View {
        HStack {
            Text(tuple.0 + (tuple.1.isEmpty ? "" : " -"))
                .setSubtitle()
            Text(tuple.1)
                .setContent()
            Spacer()
        }
        .foregroundStyle(.gray)
    }
}

#Preview {
    CountryCellField(tuple: ("Capital", "Berlin"))
}
