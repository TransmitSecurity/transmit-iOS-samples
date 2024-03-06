//
//  GetAccessTokenRequest.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation
import TSCoreSDK


class GetAccessTokenResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

class GetAccessTokenRequest: TSBaseNetworkRequest {
    typealias ParamsKeys = Constants.Network.ParamsKeys
    typealias HeadersKeys = Constants.Network.HeadersKeys
    
    private let clientId: String
    private let clientSecret: String
    private let baseURL: String
    private let path = "/oidc/token"
    
    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    
    init(baseURL: String, clientId: String, clientSecret: String) {
        self.baseURL = baseURL
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    func urlHost() -> String? {
        "\(baseURL)\(path)"
    }
    
    func httpBody() -> Data? {
        let params: [String: String] = [
            ParamsKeys.clientId: clientId,
            ParamsKeys.clientSecret: clientSecret,
            ParamsKeys.grantType: Constants.Network.GrantType.credantials
        ]
        let queryString = params.toQueryParamsString()
        
        return queryString.data(using: .utf8)
    }
    
    func headers() -> [String : String]? {
        return [HeadersKeys.contentType: "application/x-www-form-urlencoded"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        nil
    }
}
