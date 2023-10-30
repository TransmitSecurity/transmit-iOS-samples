//
//  GetAccessTokenRequest.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
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
    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    
    private let baseURL = Constants.Network.baseUrl

    private let path = "/oidc/token"
    private let clientId: String
    private let clientSecret: String
    
    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    func urlHost() -> String? {
        "\(baseURL)\(path)"
    }
    
    func httpBody() -> Data? {
        let params: [String: String] = [
            Constants.ParamsKeys.clientId: clientId,
            Constants.ParamsKeys.clientSecret: clientSecret,
            Constants.ParamsKeys.grantType: Constants.GrantType.credantials,
        ]
        let queryString = params.toQueryParamsString()
        
        return queryString.data(using: .utf8)
    }
    
    func headers() -> [String : String]? {
        return [Constants.HeadersKeys.contentType: "application/x-www-form-urlencoded"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        nil
    }
}
