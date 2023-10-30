//
//  PrimaryButtonStyle.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var textColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 35)
            .font(Font.custom(Constants.Fonts.Inter.regular, size: 14)).foregroundColor(textColor)
            .background(backgroundColor)
            .cornerRadius(15.0)
            .opacity(configuration.isPressed ? 0.8: 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
