//
//  ContentViewModel.swift
//  drs-ios-swiftui-example-app
//
//  Created by Tomer Picker on 20/06/2023.
//

import SwiftUI
import AccountProtection


class ContentViewModel: ObservableObject {
    @Published var userId: String = ""
    @Published var actionSelection = "login"
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
   let actionTypes = ["login", "register", "transaction", "password_reset", "logout", "checkout", "account_details_change", "account_auth_change", "withdraw", "credits_change"]
    
    
    func setUserId() {
        guard !userId.isEmpty else {
            setAlert(title: "Error", message: "User id field is empty")
            return
        }
        
        TSAccountProtection.setUserId(userId)
    }
    
    func clearUser() {
        TSAccountProtection.clearUser()
    }
    
    func reportAction() {
        TSAccountProtection.triggerAction(actionSelection) { result in

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    debugPrint("token: \(response.actionToken)")
                    self.setAlert(title: "Action: \(self.actionSelection) was successfully sent to server", message: "token: \(response.actionToken)")
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    let errorMessage: String
                    switch error {
                    case .disabled:
                        errorMessage = "Action is Disabled"
                    case .connectionError:
                        errorMessage = "Connection Error"
                    case .internalError:
                        errorMessage = "Internal Error"
                    case .notSupportedActionError:
                        errorMessage = "Action: \(self.actionSelection) IS NOT SUPPORTED"
                    @unknown default:
                        errorMessage = "Unknown Error"
                    }
                    self.setAlert(title: "Error was encountered", message: errorMessage)
                }
            }
        }
    }
    
    private func setAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

}
