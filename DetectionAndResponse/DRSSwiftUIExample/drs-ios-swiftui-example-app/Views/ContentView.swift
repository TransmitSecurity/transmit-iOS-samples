//
//  ContentView.swift
//  drs-ios-swiftui-example-app
//
//  Created by Tomer Picker on 25/04/2023.
//

import SwiftUI
import AccountProtection

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack{
            Constants.Icon.appLogo
            TextField("", text: $viewModel.userId, prompt: Text("Enter here your user id").foregroundColor(.gray))
                .foregroundColor(.black)
                .padding()
                .frame(height: 54)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16).stroke(.gray, lineWidth: 1))
                   .padding(.top, 32)
            HStack {
                Spacer()
                CustomButton( text: "SET USER") {
                    viewModel.setUserId()
                }
                CustomButton( text: "CLEAR USER") {
                    viewModel.clearUser()
                }
            }
            HStack {
                Text("Select action event:")
                    .foregroundColor(Color.gray)
                Spacer()
                Picker("Select action event", selection: $viewModel.actionSelection) {
                    ForEach(viewModel.actionTypes, id: \.self) {
                                    Text($0)
                                }
                            }
                .pickerStyle(.menu)
                .tint(Color.gray)
            }
            .padding(.top, 32)
            HStack {
                Spacer()
                CustomButton( text: "SEND ACTION") {
                    viewModel.reportAction()
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing], 16)
        .background(Color.white)
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text(viewModel.alertTitle),
                  message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")) {})
            })
        .onTapGesture {endEditing()}
    }
}

struct CustomButton: View {
    var text: String
    var clicked: (() -> Void)
    
    var body: some View {
        Button(action: clicked) {
            Text(text)
            .frame(height: 32)
            .padding([.leading, .trailing], 6)
            .background(Color.indigo)
            .cornerRadius(8)
            .foregroundColor(.white)
        }
    }
}

extension ContentView {
    private func endEditing() {
       UIApplication.shared.endEditing()
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}


