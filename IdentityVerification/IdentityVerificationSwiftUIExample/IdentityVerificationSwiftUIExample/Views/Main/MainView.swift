//
//  MainView.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import SwiftUI

enum MainViewTextConstants {
    case header
    case subTitle
    case termsAndConditions
    case start
    
    var title: String {
        get {
            switch self {
            case .header:
                return "Prepare For Verification"
            case .subTitle:
                return "This should take a few moments. In order to assure the verification succeeds, please make sure that"
            case .termsAndConditions:
                return "I agree to the [Terms & Conditions](\(Constants.Links.termsOfService)) and the [Privacy Policy](\(Constants.Links.privacyStatement))"
            case .start:
                return "Continue"
            }
        }
    }
}

struct MainView : View {
    @ObservedObject var viewModel: MainViewModel
    @State var isChecked = false

    var body: some View {
        ScrollView {
            VStack {
                Constants.Icons.logo
                VStack(spacing: 12) {
                    Text(MainViewTextConstants.header.title).font(Font.custom(Constants.Fonts.Inter.semiBold, size: 24)).foregroundColor(Color.black).multilineTextAlignment(.center)
                    Text(MainViewTextConstants.subTitle.title).font(Font.custom(Constants.Fonts.Inter.regular, size: 16)).foregroundColor(Color.black).multilineTextAlignment(.center)
                }.padding(.top, 45)
                GenericListView(cells: viewModel.prepareVerificationData)
                    .frame(height: 200)
                    .padding(.top, 40)
                Divider()
                Checkbox(isChecked: $isChecked, text: MainViewTextConstants.termsAndConditions.title)
                    .padding(.top, 32)
                Button(action: {
                    viewModel.startSession()
                }) {
                    Text(MainViewTextConstants.start.title)
                }.disabled(!isChecked)
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: isChecked ? Constants.Colors.primaryBlue : Constants.Colors.primaryGrey))
                    .padding(.top, 32)
            }
            .padding([.top], 45)
            .padding([.leading, .trailing], 24)
            .overlay(viewModel.isLoading ? LoaderView(tintColor: .gray, scaleSize: 3.0) : nil
            )
            .allowsHitTesting(!viewModel.isLoading)
        }.background(Color.white)
        .navigate(to: VerificationProcessView(viewModel: VerificationProcessViewModel()), when: $viewModel.moveToVerificationProcessView)
    }
}

extension MainView {
    private func ActionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: { action() } ) {
            Text(title).frame(maxWidth: .infinity, minHeight: 40)
        }.buttonStyle(.automatic)
            .foregroundColor(.white)
            .background(Color(red: 88/255, green: 86/255, blue: 214/255))
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .cornerRadius(10)
    }
}

struct Checkbox: View {
    @Binding var isChecked : Bool
    var text: String
    func toggle() { isChecked = !isChecked }
    
    var body: some View {
        Button(action: toggle){
            HStack{
                Image(systemName: isChecked ? "checkmark.square.fill": "square").foregroundColor(isChecked ? Constants.Colors.primaryBlue : .black)
                Text(.init(text)).font(Font.custom(Constants.Fonts.Inter.regular, size: 14)).foregroundColor(Color.black).multilineTextAlignment(.leading)
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}



