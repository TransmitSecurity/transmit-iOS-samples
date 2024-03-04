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
    private init() { }
        
    private var totpInfoItems: [TOTPInfo] = []
    
    struct StorageKeys {
        static let totpInfo = "totp_info_key"
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
    
    func addItem(_ item: TOTPInfo) {
        totpInfoItems.append(item)
        saveItems()
    }
    
    func getItems() -> [TOTPInfo] {
       return totpInfoItems
    }
    
    func fetchItems() -> [TOTPInfo] {
        
        guard let data = userDefaults.data(forKey: StorageKeys.totpInfo) else { return [] }
        
        let decoder = JSONDecoder()
        let items = try? decoder.decode([TOTPInfo].self, from: data)
        
        totpInfoItems = items ?? []
        
        return totpInfoItems
    }
    
    
    func saveItems() {
     
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(totpInfoItems)
        
        userDefaults.set(data, forKey: StorageKeys.totpInfo)
        userDefaults.synchronize()
    }
    
    
}
