//
//  InfoPopupView.swift
//  idv-ios-sample-app
//
//  Created by Tomer Picker on 20/08/2023.
//

import Foundation
import SwiftUI

struct InfoPopupView: View {
    @Binding var showPopup: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Button(action: {
                    showPopup.toggle()
                }) {
                    Image(systemName: "xmark.circle")
                        .padding(.bottom, 20)
                }
                Spacer()
            }
            VStack(alignment: .trailing) {
                Text("Please sign up first to access your account")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct InfoPopupView_Previews: PreviewProvider {
    
    static var previews: some View {
        InfoPopupView(showPopup: .constant(true))
    }
}
