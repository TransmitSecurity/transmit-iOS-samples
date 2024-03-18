//
//  LoaderView.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 11/09/2023.
//

import SwiftUI

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
    
    static var basic: AnyView {
        AnyView(LoaderView(tintColor: .gray, scaleSize: 3))
    }
}

