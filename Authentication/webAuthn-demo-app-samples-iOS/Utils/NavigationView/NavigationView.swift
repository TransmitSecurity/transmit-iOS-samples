//
//  ViewNavigation.swift
//  identity-orchestration-ios-demo-app
//
//  Created by Igor Babitski on 28/08/2023.
//

import SwiftUI

struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>, hideNavigationBar: Bool = true, title: String = "") -> some View {
        NavigationView {
            ZStack {
                self.navigationBarTitle(title)
                    .navigationBarHidden(hideNavigationBar)
                
                NavigationLink(
                    destination: view
                        .navigationBarTitle(title)
                        .navigationBarHidden(hideNavigationBar),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
