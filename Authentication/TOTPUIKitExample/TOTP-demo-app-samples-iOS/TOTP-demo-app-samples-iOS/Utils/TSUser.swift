//
//  TSUser.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 07/03/2024.
//

import Foundation

final class TSCredentials: NSObject, Codable {
    var password: String?
    var forceReplace: Bool? = nil
    
    enum CodingKeys: String, CodingKey {
        case password
        case forceReplace = "force_replace"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.password, forKey: .password)
        try container.encodeIfPresent(self.forceReplace, forKey: .forceReplace)

    }
}

final class TSUser: NSObject, Codable {
    var username: String?
    var email: String?
    var credentials: TSCredentials?
    
    enum CodingKeys: CodingKey {
        case username
        case email
        case credentials
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(credentials, forKey: .credentials)
    }

    
    static func makeMockUser(username: String?, email: String, password: String) -> TSUser {
        
        let user = TSUser()
        
        user.username = username
        user.email = email
        
        let credantials = TSCredentials()
        credantials.password = password
        credantials.forceReplace = false
        
        user.credentials = credantials
        
        return user
    }
}
