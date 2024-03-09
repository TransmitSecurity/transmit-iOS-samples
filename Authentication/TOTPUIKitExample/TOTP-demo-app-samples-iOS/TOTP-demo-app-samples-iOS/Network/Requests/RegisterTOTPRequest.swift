//
//  RegisterTOTPRequest.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation
import TSCoreSDK

class TSRegisterTOTPResponse: TSResponse {
    var responseHeaders: [String : String]?
    
    var secret: String
    
    let uri: String
}

class TSRegisterTOTPRequest: TSBaseNetworkRequest {
    private let path = "cis/v1/users/me/totp"

    typealias HeadersKeys = Constants.Network.HeadersKeys
    
    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    
    private let baseURL: String
    
    private let accessToken: String
    
    private let label: String
    
    
    struct Body: Encodable {
        let label: String
        
        let allowOverride: Bool
    }
    
    var service: TSNetworkService<TSRegisterTOTPRequest, TSRegisterTOTPResponse> { .init(request: self) }
    
    init(baseURL: String, accessToken: String, label: String) {
        self.baseURL = baseURL
        self.accessToken = accessToken
        self.label = label
    }
    
    func httpBody() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
    
        let body = Body(label: label, allowOverride: true)
        let bodyData = try? encoder.encode(body)
        
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


