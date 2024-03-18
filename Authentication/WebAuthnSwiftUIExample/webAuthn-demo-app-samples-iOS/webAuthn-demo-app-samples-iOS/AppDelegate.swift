//
//  AppDelegate.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import UIKit
import TSAuthenticationSDK
import AccountProtection

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        SdkController.shared.initializeAccountProtectionSDK()
        
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


    func initializeWebAuthnSDK() {
        let config = TSConfiguration(domain: AppConfiguration.shared.getDomain())
        TSAuthentication.shared.initialize(baseUrl: "\(AppConfiguration.shared.getBaseURL())/v1", clientId: AppConfiguration.shared.getClientId(), configuration: config)
        TSAccountProtection.initialize(clientId: Constants.App.clientId)
    }
}

