//
//  drs_ios_swiftui_example_appApp.swift
//  drs-ios-swiftui-example-app
//
//  Created by Tomer Picker on 25/04/2023.
//

import SwiftUI
import AccountProtection

@main
struct drs_ios_swiftui_example_appApp: App {
    
    init() {
        TSAccountProtection.initialize(clientId: Constants.App.clientId)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
