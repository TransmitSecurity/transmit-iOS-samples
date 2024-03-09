//
//  CreateUserRequest.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation
import TSCoreSDK

class TSCreateUserResponse: TSResponse {
    struct Email: Codable {
        let value: String?
        
        let emailVerified: Bool
        
        enum CodingKeys: String, CodingKey {
            case value
            case emailVerified = "email_verified"
        }
    }
    
    struct PasswordInformation: Codable {
        let updatedAt: Int64?
        
        let expired: Bool?
        
        let temporary: Bool?
        
        enum CodingKeys: String, CodingKey {
            case updatedAt = "updated_at"
            case expired
            case temporary
        }
    }
    
    struct Result: Codable {
        let userId: String?
        
        let createdAt: Int64?
        
        let updatedAt: Int64?
        
        let status: String?
        
        let email: Email?
        
        let appId: String?
        
        let passwordInformation: PasswordInformation?
        
        let appName: String?
        
        let username: String?
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<TSCreateUserResponse.Result.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
            self.createdAt = try container.decodeIfPresent(Int64.self, forKey: .createdAt)
            self.updatedAt = try container.decodeIfPresent(Int64.self, forKey: .updatedAt)
            self.status = try container.decodeIfPresent(String.self, forKey: .status)
            self.email = try container.decodeIfPresent(TSCreateUserResponse.Email.self, forKey: .email)
            self.appId = try container.decodeIfPresent(String.self, forKey: .appId)
            self.passwordInformation = try container.decodeIfPresent(TSCreateUserResponse.PasswordInformation.self, forKey: .passwordInformation)
            self.appName = try container.decodeIfPresent(String.self, forKey: .appName)
            self.username = try container.decodeIfPresent(String.self, forKey: .username)
        }
        
        enum CodingKeys: String, CodingKey {
            case userId = "used_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case status
            case email
            case appId = "app_id"
            case passwordInformation = "password_information"
            case appName = "app_name"
            case username
        }
        
    }
    
    var responseHeaders: [String : String]?
    
    let result: Result?
}

class TSCreateUserRequest: TSBaseNetworkRequest {
    private let path = "cis/v1/users"
    
    typealias HeadersKeys = Constants.Network.HeadersKeys
    
    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    
    private let baseURL: String
    
    private let accessToken: String
        
    private let user: TSUser
    
    var service: TSNetworkService<TSCreateUserRequest, TSCreateUserResponse> { .init(request: self) }
    
    init(baseURL: String, accessToken: String, user: TSUser) {
        self.baseURL = baseURL
        self.accessToken = accessToken
        self.user = user
    }
    
    func httpBody() -> Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
    
        let bodyData = try? encoder.encode(user)
        
        return bodyData
    }
    
    func urlHost() -> String? {
        "\(baseURL)/\(path)"
    }
    
    func headers() -> [String : String]? {
        return [HeadersKeys.authorization: "Bearer \(accessToken)"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        nil
    }
}


