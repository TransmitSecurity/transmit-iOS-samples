//
//  MainView.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import SwiftUI

enum MainViewTextConstants {
    case header
    case subTitle
    case register
    case login

    var title: String {
        get {
            switch self {
            case .header:
                return "Welocome to GCash"
            case .subTitle:
                return "Turn your phone into a secure e-wallet. Use it across all networks, with no data charges for Globe & TM."
            case .register:
                return "REGISTER"
            case .login:
                return "LOG IN"
            }
        }
    }
}

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var username: String = ""
    @State var showPopup = false

    var body: some View {
        NavigationView {
            GeometryReader { reader in
                ScrollView {
                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    self.showPopup.toggle()
                                }
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .resizable()
                                    .frame(width: 24, height: 12)
                            }
                            .frame(width: 30 , height: 30)
                            .disabled(showPopup)
                            Spacer()
                        }.padding(.top, 15)
                        NavigationLink(destination:  viewModel.nextFlowView(), isActive: $viewModel.moveToRecommendationView) {
                        }
                        HStack {
                            Constants.Icons.MainIcon
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(.top, 15)
                        Text(MainViewTextConstants.header.title).font(Font.custom(Constants.Fonts.Inter.semiBold, size: 24)).foregroundColor(Color.black).multilineTextAlignment(.center)
                        Text(MainViewTextConstants.subTitle.title).font(Font.custom(Constants.Fonts.Inter.regular, size: 16)).foregroundColor(Constants.Colors.primaryGrey).multilineTextAlignment(.center)
                            .padding(.top, 10)
                        VStack(alignment: .leading) {
                            Text("Enter your username:")
                                .font(Font.custom(Constants.Fonts.Inter.semiBold, size: 14)).foregroundColor(Color.black)
                            TextField("username", text: $username)
                                .padding(.all, 10)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Constants.Colors.primaryGrey, lineWidth: 1)
                                )
                                .font(Font.custom(Constants.Fonts.Inter.semiBold, size: 14)).foregroundColor(Color.black)
                        }.padding(.top, 25)
                        Spacer()
                        HStack(alignment: .center) {
                            Button(action: {
                                viewModel.registerButtonClicked(username)
                            }) {
                                Text(MainViewTextConstants.register.title)
                            }.buttonStyle(PrimaryButtonStyle(backgroundColor: Constants.Colors.primaryBlue, textColor: Color.white))
                            Button(action: {
                                viewModel.loginButtonClicked(username)
                            }) {
                                Text(MainViewTextConstants.login.title)
                            }.buttonStyle(PrimaryButtonStyle(backgroundColor: Color.white, textColor: Constants.Colors.primaryBlue))
                        }.padding(.bottom, 20)
                    }
                    .frame(minHeight: reader.size.height)
                }.padding([.leading, .trailing], 24)
                    .popupNavigationView(show: $showPopup) {
                            PopupView(showPopup: $showPopup)
                        }
            }.background(Color.white)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
