//
//  TSCompleteAuthenticationRequest.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//


import Foundation
import TSCoreSDK

class TSCompleteAuthenticationResponseData: NSObject, Codable {
    var accessToken: String?
    var expiresIn: Int?
    var idToken: String?
    var refreshToken: String?
    var sessionId: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case idToken = "id_token"
        case refreshToken = "refresh_token"
        case sessionId = "session_id"
    }
}


class TSCompleteAuthenticationRequest: TSBaseNetworkRequest {

    struct Body: Encodable {
        let webauthnEncodedResult: String
    }
    
    private let baseURL: String
    private let path = "/v1/auth/webauthn/authenticate"
    
    private let accessToken: String
    private let body: Body
    
    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    typealias HeadersKeys = Constants.Network.HeadersKeys

    init(baseURL: String, accessToken: String, webauthnEncodedResult: String) {
        self.baseURL = baseURL
        self.accessToken = accessToken
        body = Body(webauthnEncodedResult: webauthnEncodedResult)
    }
    
    func urlHost() -> String? {
        "\(baseURL)/\(path)"
    }
    
    func httpBody() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let bodyData = try? encoder.encode(body)
        return bodyData
    }
    
    func headers() -> [String : String]? {
        return [HeadersKeys.authorization: "Bearer \(accessToken)"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        nil
    }
}
