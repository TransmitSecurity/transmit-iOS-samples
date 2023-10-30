//
//  AppDelegate.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import UIKit
import SwiftUI
import IdentityVerification

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        TSIdentityVerification.initialize(clientId: Constants.App.clientId)
        TSIdentityVerification.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: TSIdentityVerificationDelegate {
    
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
    
    func verificationDidFail(with error: TSIdentityVerificationError) {
        let status: VerificationProcessState = error == IdentityVerification.TSIdentityVerificationError.cameraPermissionRequired ? .cameraPermissionError : .generalError
        VerificationProcessStatus.shared.status.send(status)
        debugPrint("Verification error: \(error)")
    }
    
    func verificationDidCancel() {
        debugPrint("canceled by user")
    }
}
