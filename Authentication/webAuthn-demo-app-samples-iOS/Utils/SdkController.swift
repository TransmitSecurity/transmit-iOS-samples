//
//  SdkController.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Igor Babitski on 29/10/2023.
//

import Foundation
import TSAuthenticationSDK
import AccountProtection

final class SdkController {
    static let shared = SdkController()
    
    private init() {
        
    }
    
    func initializeWebAuthnSDK() {
        let config = TSConfiguration(domain: AppConfiguration.shared.getDomain())
        TSAuthentication.shared.initialize(baseUrl: "\(AppConfiguration.shared.getBaseURL())/v1", clientId: AppConfiguration.shared.getClientId(), configuration: config)
    }
    
    func initializeAccountProtectionSDK() {
        TSAccountProtection.initialize(clientId: Constants.App.clientId)
    }
}
