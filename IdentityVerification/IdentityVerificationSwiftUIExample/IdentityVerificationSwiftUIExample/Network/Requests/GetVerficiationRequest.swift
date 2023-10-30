//
//  GetVerficiationRequest.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import TSCoreSDK

class GetVerficiationResponse: Codable {
    let sessionId: String?
    let status: String?
    let recommendation: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case status
        case recommendation
    }
}


class GetVerficiationRequest: TSBaseNetworkRequest {
    typealias HeadersKeys = Constants.HeadersKeys

    var httpMethod: TSCoreSDK.TSHttpMethod = .GET
    
    private let baseURL = Constants.Network.baseUrl
    private let path = "/verify/api/v1/verification/"
    private let sessionID: String
    private let accessToken: String

    init(sessionID: String, accessToken: String) {
        self.accessToken = accessToken
        self.sessionID = sessionID
    }
    
    struct Body: Encodable {
        let autoStart: Bool
    }
    
    func urlHost() -> String? {
        "\(baseURL)\(path)\(sessionID)/result"
    }
    
    func httpBody() -> Data? {
        nil
    }
    
    func headers() -> [String : String]? {
        return [HeadersKeys.authorization: "Bearer \(accessToken)"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        nil
    }
}
