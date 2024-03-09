//
//  DataManager.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import Foundation

class DataManager {
    
    private let userDefaults = UserDefaults.standard
    static let shared: DataManager = .init()
    private (set) var username: String?
    private init() { }
        
    private var totpQRInfoItems: [TOTPInfo] = []
    private var totpSilentInfoItems: [TOTPInfo] = []
    
    struct StorageKeys {
        static let totpQRInfo = "totp_qr_info_key"
        static let totpSilentInfo = "totp_silent_info_key"
        static let loginInfo = "login_info_key"
    }
    
    enum TOTPType {
        case qr
        case silent
        
        var storageKey: String {
            get{
                switch self {
                case .qr:
                    return StorageKeys.totpQRInfo
                case .silent:
                    return StorageKeys.totpSilentInfo
                }
            }
        }
    }
    
    
    struct TOTPInfo: Codable {
        let issuer: String
        
        let label: String
                
        let uuid: String
        
        var biometric: Bool
        
        mutating func setIsBiometric(_ value: Bool) {
            self.biometric = value
        }
    }
    
    struct LoginInfo: Codable {
        let username: String
        
        let password: String
        
        let userToken: String
    }
    
    func addItem(_ item: TOTPInfo, type: TOTPType) {
        switch type {
        case .qr:
            totpQRInfoItems.append(item)
        case .silent:
            totpSilentInfoItems.append(item)
        }
        saveItems(forType: type)
    }
    
    func getItems(forType type: TOTPType) -> [TOTPInfo] {
        switch type {
        case .qr:
            return totpQRInfoItems
        case .silent:
            return totpSilentInfoItems
        }
    }
    
    func fetchItems(forType type: TOTPType) -> [TOTPInfo] {
        
        guard let data = userDefaults.data(forKey: type.storageKey) else { return [] }
        
        let decoder = JSONDecoder()
        let items = try? decoder.decode([TOTPInfo].self, from: data)
        
        switch type {
        case .qr:
            totpQRInfoItems = items ?? []
            return totpQRInfoItems
        case .silent:
            totpSilentInfoItems = items ?? []
            return totpSilentInfoItems
        }
    }
    
    
    func saveItems(forType type: TOTPType) {
        let totpInfoItems = type == .qr ? totpQRInfoItems : totpSilentInfoItems
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(totpInfoItems)
        
        userDefaults.set(data, forKey: type.storageKey)
        userDefaults.synchronize()
    }
    
    var loggedInUsername: String? {
        getLoginInfo()?.username
    }
    
    func saveLoginInfo(_ value: LoginInfo) {
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(value)
        
        userDefaults.set(data, forKey: StorageKeys.loginInfo)
        userDefaults.synchronize()
    }
    
    func getLoginInfo() -> LoginInfo? {
        guard let data = userDefaults.data(forKey: StorageKeys.loginInfo) else { return nil }
        
        let decoder = JSONDecoder()
        let info = try? decoder.decode(LoginInfo.self, from: data)
    
        return info
    }
    
    func isUserLoggedIn() -> Bool {
        getLoginInfo() != nil
    }
    
    func setUsername(_ username: String?) {
        self.username = username
    }
    
    func logout() {
        userDefaults.removeObject(forKey: StorageKeys.loginInfo)
        userDefaults.removeObject(forKey: StorageKeys.totpSilentInfo)
        totpSilentInfoItems = []
        userDefaults.synchronize()
    }
    
    
}
