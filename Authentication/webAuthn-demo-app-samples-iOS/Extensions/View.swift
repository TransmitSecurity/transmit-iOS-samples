//
//  View.swift
//  idv-ios-sample-app
//
//  Created by Tomer Picker on 15/06/2023.
//

import SwiftUI

extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
    
    func popupNavigationView<Content: View>(show: Binding<Bool>, horizontalPadding: CGFloat = 40, @ViewBuilder content: @escaping ()->Content)->some View {
        return self.overlay {
                if show.wrappedValue {
                    GeometryReader { proxy in
                        Color.gray
                            .opacity(0.15)
                            .ignoresSafeArea()
                        let size = proxy.size
                        content()
                        .frame(width: size.width - horizontalPadding, height: size.height / 1.2, alignment: .center)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
    }
}
