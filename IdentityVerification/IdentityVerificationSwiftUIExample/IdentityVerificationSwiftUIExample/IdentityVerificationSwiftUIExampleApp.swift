//
//  IdentityVerificationSwiftUIExampleApp.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI
import IdentityVerification

@main
struct IdentityVerificationSwiftUIExampleApp: App {
    private let idvObserver = IDVStatusObserver()
    
    init() {
        TSIdentityVerification.initialize(clientId: Constants.App.clientId)
        TSIdentityVerification.delegate = idvObserver
    }

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
        }
    }
}

private class IDVStatusObserver: TSIdentityVerificationDelegate {
    
    func verificationDidStartProcessing() {
        VerificationProcessStatus.shared.status.send(.processing)
        debugPrint("processing")
    }
    
    func verificationRequiresRecapture(reason: TSRecaptureReason) {
        VerificationProcessStatus.shared.status.send(.recapture(reason))
        debugPrint("recapture reason: \(reason.rawValue)")
    }
    
    func verificationDidComplete() {
        VerificationProcessStatus.shared.status.send(.completed)
        debugPrint("completed")
    }

    func verificationDidFail(with error: IdentityVerification.TSIdentityVerificationError) {
        let status: VerificationProcessState = error == IdentityVerification.TSIdentityVerificationError.cameraPermissionRequired ? .cameraPermissionError : .generalError
        VerificationProcessStatus.shared.status.send(status)
        debugPrint("Verification error: \(error)")
    }
    
    func verificationDidCancel() {
        debugPrint("canceled by user")
    }
    

}
