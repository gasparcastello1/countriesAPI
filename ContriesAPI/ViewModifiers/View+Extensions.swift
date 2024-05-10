//
//  ViewModifiers.swift
//  ContriesAPI
//
//  Created by Gaspar Castello on 05/05/2024.
//

import SwiftUI

struct CustomFontModifier: ViewModifier {
    var size: CGFloat
    var weight: Font.Weight
    var design: Font.Design

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

extension View {
    func customFont(size: CGFloat, weight: Font.Weight, design: Font.Design) -> some View {
        self.modifier(CustomFontModifier(size: size, weight: weight, design: design))
    }
}

extension Text {
    func setTitle() -> Text {
        self.font(.system(size: 20, weight: .bold, design: .default))
    }
    
    func setSubtitle() -> Text {
        self.font(.system(size: 16, weight: .bold, design: .default))
    }
    
    func setContent() -> Text {
        self.font(.system(size: 14, weight: .light, design: .default))
    }
}
