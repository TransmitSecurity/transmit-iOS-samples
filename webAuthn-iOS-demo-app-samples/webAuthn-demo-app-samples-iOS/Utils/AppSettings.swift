//
//  AppSettings.swift
//  idv-ios-sample-app
//
//  Created by Tomer Picker on 17/07/2023.
//

import Foundation
import Combine

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var baseURL: String {
        didSet {
            UserDefaults.standard.set(baseURL, forKey: "BASE_URL")
        }
    }
    
    @Published var domain: String {
        didSet {
            UserDefaults.standard.set(domain, forKey: "DOMAIN")
        }
    }
    
    @Published var clientId: String {
        didSet {
            UserDefaults.standard.set(clientId, forKey: "CLIENT_ID")
        }
    }
    
    @Published var clientSecret: String {
        didSet {
            UserDefaults.standard.set(clientSecret, forKey: "CLIENT_SECRET")
        }
    }
      
    private init() {
      self.baseURL = UserDefaults.standard.object(forKey: "BASE_URL") as? String ?? "https://api.transmitsecurity.io/cis"
      self.domain = UserDefaults.standard.object(forKey: "DOMAIN") as? String ?? "shopcart.userid-stg.io"
      self.clientId = UserDefaults.standard.object(forKey: "CLIENT_ID") as? String ?? "5nhc16n9f165t4gp0todzd37qzfr9oxq"
      self.clientSecret = UserDefaults.standard.object(forKey: "CLIENT_SECRET") as? String ?? "aa14b16a-87fb-43aa-8372-df130b25d1ad"
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
