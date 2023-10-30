//
//  TSCompleteRegistrationRequest.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import Foundation
import TSCoreSDK

class TSCompleteRegistrationResponseData: NSObject, Codable {
    var webauthnSessionId: String?
    var userId: String?
    var externalUserId: String?
    var credentialId: String?
    var webauthnUsername: String?
    var isUserCreated: Bool?

    enum CodingKeys: String, CodingKey {
        case webauthnSessionId = "webauthn_session_id"
        case userId = "user_id"
        case externalUserId = "external_user_id"
        case credentialId = "credential_id"
        case webauthnUsername = "webauthn_username"
        case isUserCreated = "is_user_created"
    }
}


class TSCompleteRegistrationRequest: TSBaseNetworkRequest {

    struct Body: Encodable {
        let webauthnEncodedResult: String
        let externalUserId: String
        let externalUserIdentifier: String
    }
    
    private let path = "/v1/auth/webauthn/external/register"
    
    private let accessToken: String
    private let body: Body
    private let baseURL: String
    
    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    typealias HeadersKeys = Constants.Network.HeadersKeys
    
    init(baseURL: String, accessToken: String, webauthnEncodedResult: String, externalUserId : String, externalUserIdentifier: String) {
        self.baseURL = baseURL
        self.accessToken = accessToken
        body = Body(webauthnEncodedResult: webauthnEncodedResult, externalUserId: externalUserId, externalUserIdentifier: externalUserIdentifier)
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
