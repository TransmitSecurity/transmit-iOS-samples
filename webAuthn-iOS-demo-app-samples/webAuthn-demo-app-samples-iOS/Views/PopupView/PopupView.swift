//
//  PopupView.swift
//  idv-ios-sample-app
//
//  Created by Tomer Picker on 17/07/2023.
//

import SwiftUI

struct PopupView: View {
    @State private var baseUrl: String = AppSettings.shared.getBaseURL()
    @State private var domain: String = AppSettings.shared.getDomain()
    @State private var clientId: String = AppSettings.shared.getClientId()
    @State private var clientSecret: String = AppSettings.shared.getClientSecret()
    @Binding var showPopup: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                showPopup.toggle()
            }) {
                Image(systemName: "xmark.circle")
                    .padding(.bottom, 20)
            }
            VStack(alignment: .leading) {
                Text("Set base URL:")
                    .foregroundColor(Color.black)
                TextField("base URL", text: $baseUrl)
                    .padding(.all, 10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Constants.Colors.primaryGrey, lineWidth: 1)
                    )
                    .foregroundColor(Color.black)
            }
            VStack(alignment: .leading) {
                Text("Set domain:")
                    .foregroundColor(Color.black)
                TextField("domain", text: $domain)
                    .padding(.all, 10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Constants.Colors.primaryGrey, lineWidth: 1)
                    )
                    .foregroundColor(Color.black)
            }
            VStack(alignment: .leading) {
                Text("Set client id:")
                    .foregroundColor(Color.black)
                TextField("client id", text: $clientId)
                    .padding(.all, 10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Constants.Colors.primaryGrey, lineWidth: 1)
                    )
                    .foregroundColor(Color.black)
            }
            VStack(alignment: .leading)  {
                Text("Set client secret:")
                    .foregroundColor(Color.black)
                TextField("client secret", text: $clientSecret)
                    .padding(.all, 10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Constants.Colors.primaryGrey, lineWidth: 1)
                    )
                    .foregroundColor(Color.black)
            }
            HStack {
                Text("Select environment:")
                    .foregroundColor(Color.black)
            }
            Button(action: {
                setClientCredentials(baseUrl: baseUrl, domain: domain, clientId: clientId, clientSecret: clientSecret)
                showPopup.toggle()
            }) {
                Text("Set")
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: Constants.Colors.primaryBlue, textColor: .white))
            .padding(.top, 32)
        Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    }
}

extension PopupView {
    func setClientCredentials(baseUrl: String, domain: String, clientId: String, clientSecret: String) {
        AppSettings.shared.baseURL = baseUrl
        AppSettings.shared.domain = domain
        AppSettings.shared.clientId = clientId
        AppSettings.shared.clientSecret = clientSecret
     //   initSDK()
    }
    
    func initSDK() {
     //   SdkController.shared.initializeWebAuthnSDK()
    }
}

struct PopupView_Previews: PreviewProvider {
    
    static var previews: some View {
        PopupView(showPopup: .constant(true))
    }
}
