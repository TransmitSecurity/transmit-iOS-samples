//
//  VerificationProcessResubmitView.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI
import IdentityVerification


struct VerificationProcessResubmitView: View {
    @State var state: TSRecaptureReason
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 12) {
                Text(state.title).font(Font.custom(Constants.Fonts.Inter.semiBold, size: 24)).foregroundColor(Color.black).multilineTextAlignment(.center)
                Text(state.description).font(Font.custom(Constants.Fonts.Inter.regular, size: 16)).foregroundColor(Color.black).multilineTextAlignment(.center)
            }.padding(.top, 45)
            VStack(alignment: .leading, spacing: 18) {
                if !state.subDescription.isEmpty {
                    Text(state.subDescription).font(Font.custom(Constants.Fonts.Inter.semiBold, size: 14)).foregroundColor(Color.black)
                }
                GenericListView(cells: state.listData)
                    .frame(height: 200)
            }
            .padding(.top, 35)
        }
    }
}

struct VerificationProcessResubmitView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationProcessResubmitView(state: .imageMissing)
    }
}
