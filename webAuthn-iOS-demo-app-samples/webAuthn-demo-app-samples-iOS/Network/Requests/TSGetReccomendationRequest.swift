//
//  TSGetReccomendationRequest.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 11/09/2023.
//

import Foundation
import TSCoreSDK

class TSGetReccomendationResponse: NSObject, Codable {
    var id: String?
    var recommendation: ReccomendationRsponseType?
    var riskScore: Double?
    var reasons: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case recommendation = "recommendation"
        case riskScore = "risk_score"
        case reasons
    }
}

class ReccomendationRsponseType: NSObject, Codable {
    var type: String?

    enum CodingKeys: String, CodingKey {
        case type
    }
}


class TSGetReccomendationRequest: TSBaseNetworkRequest {

    typealias ParamsKeys = Constants.Network.ParamsKeys
    typealias HeadersKeys = Constants.Network.HeadersKeys
    
    private let baseURL: String = "https://api.transmitsecurity.io/risk"
    private let path = "/v1/recommendation"
    
    private let actionToken: String
    private let accessToken: String
    var httpMethod: TSCoreSDK.TSHttpMethod = .GET
    
    init(accessToken: String, actionToken: String) {
        self.accessToken = accessToken
        self.actionToken = actionToken
    }
    
    func urlHost() -> String? {
        "\(baseURL)\(path)"
    }
    
    func httpBody() -> Data? {
        return nil
    }
    
    func headers() -> [String : String]? {
        return [HeadersKeys.authorization: "Bearer \(accessToken)"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        let params: [String: String] = [
            ParamsKeys.actionToken: actionToken,
            ParamsKeys.userId: "REPLACE_WITH_USER_ID"
        ]
        
        return params
    }
}

