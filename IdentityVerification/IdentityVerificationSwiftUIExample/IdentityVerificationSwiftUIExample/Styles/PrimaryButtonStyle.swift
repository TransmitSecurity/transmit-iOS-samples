//
//  PrimaryButtonStyle.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .font(Font.custom(Constants.Fonts.Inter.regular, size: 16)).foregroundColor(Color.white)
            .background(backgroundColor)
            .cornerRadius(4.0)
            .opacity(configuration.isPressed ? 0.8: 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
