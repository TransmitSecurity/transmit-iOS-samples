//
//  LoginWithPasswordRequest.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation
import TSCoreSDK

class TSLoginWithPasswordResponse: TSResponse {
    var responseHeaders: [String : String]?
    
    let accessToken: String
    
    let refreshToken: String
    
    let expiresIn: Int64?
    
    let tokenType: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

class TSLoginWithPasswordRequest: TSBaseNetworkRequest {
    typealias ParamsKeys = Constants.Network.ParamsKeys
    typealias HeadersKeys = Constants.Network.HeadersKeys
    
    private let path = "oidc/token/"

    
    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    
    private let baseURL: String
    
    private let username: String
    
    private let clientId: String
    
    private let clientSecret: String
    
    private let password: String

    var service: TSNetworkService<TSLoginWithPasswordRequest, TSLoginWithPasswordResponse> { .init(request: self) }
    
    init(baseURL: String, clientId: String, clientSecret: String, username: String, password: String) {
        self.baseURL = baseURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.username = username
        self.password = password
    }
    
    func httpBody() -> Data? {
        let params: [String: String] = [
            ParamsKeys.username: username,
            ParamsKeys.password: password,
            ParamsKeys.clientId: clientId,
            ParamsKeys.clientSecret: clientSecret,
            ParamsKeys.grantType: "password",
            ParamsKeys.usernameType: "email"
        ]
        let queryString = params.toQueryParamsString()
        
        return queryString.data(using: .utf8)
    }
    
    func urlHost() -> String? {
        "\(baseURL)/\(path)"
    }
    
    func headers() -> [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        nil
    }
}


