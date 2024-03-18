//
//  AppSettings.swift
//  idv-ios-sample-app
//
//  Created by Tomer Picker on 17/07/2023.
//

import Foundation
import Combine

class AppConfiguration: ObservableObject {
    static let shared = AppConfiguration()

    
    struct InitialConfiguration {
        static let baseURL = "<YOUR_BASE_URL>"
        
        static let domain = "<YOUR_DOMAIN>"
        
        static let clientId = "<YOUR_CLIENT_ID>"
        
        static let clientSecret =
    }
    
    @Published var baseURL: String {
        didSet {
            UserDefaults.standard.set(baseURL, forKey: UserDefaults.WebAuthnKeys.baseURL)
        }
    }
    
    @Published var domain: String {
        didSet {
            UserDefaults.standard.set(domain, forKey: UserDefaults.WebAuthnKeys.domain)
        }
    }
    
    @Published var clientId: String {
        didSet {
            UserDefaults.standard.set(clientId, forKey: UserDefaults.WebAuthnKeys.clientId)
        }
    }
    
    @Published var clientSecret: String {
        didSet {
            UserDefaults.standard.set(clientSecret, forKey: UserDefaults.WebAuthnKeys.clientSecret)
        }
    }
      
    private init() {
        self.baseURL = UserDefaults.standard.object(forKey: UserDefaults.WebAuthnKeys.baseURL) as? String ?? InitialConfiguration.baseURL
        
        self.domain = UserDefaults.standard.object(forKey: UserDefaults.WebAuthnKeys.domain) as? String ?? InitialConfiguration.domain
        
        self.clientId = UserDefaults.standard.object(forKey: UserDefaults.WebAuthnKeys.clientId) as? String ?? InitialConfiguration.clientId
        
        self.clientSecret = UserDefaults.standard.object(forKey: UserDefaults.WebAuthnKeys.clientSecret) as? String ?? InitialConfiguration.clientSecret
    }
    
    func getClientId() -> String {
        return clientId
    }
    
    func getDomain() -> String {
        return domain
    }
    
    func getClientSecret() -> String {
        return clientSecret
    }
    
    func getBaseURL() -> String {
         return baseURL
     }
    
    func isCredentialsSet() -> Bool {
        return !clientId.isEmpty && !clientSecret.isEmpty
    }
}

private extension UserDefaults {
    struct WebAuthnKeys {
        static let baseURL = "base_url"
        static let domain = "domain"
        static let clientId = "client_id"
        static let clientSecret =
    }
}
