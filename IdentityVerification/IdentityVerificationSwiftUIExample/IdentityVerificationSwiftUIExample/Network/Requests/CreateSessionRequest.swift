//
//  CreateSessionRequest.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import TSCoreSDK

class CreateSessionResponse: Codable {
    let startToken: String?
    let sessionId: String?
    let expiration: String?
    let missingImages: [String]
    
    enum CodingKeys: String, CodingKey {
        case startToken = "start_token"
        case sessionId = "session_id"
        case expiration
        case missingImages = "missing_images"
    }
}


class CreateSessionRequest: TSBaseNetworkRequest {
    
    struct MockBehavior: Encodable {
        let processingTime: String
        let recommendation: String
        let forceRetry: Bool
    }
    
    struct Body: Encodable {
        let autoStart: Bool
        let mockBehavior: MockBehavior?
    }
    
    typealias HeadersKeys = Constants.HeadersKeys
    private let baseURL = Constants.Network.baseUrl
    
    private let path = "/verify/api/v1/verification"
    private let accessToken: String
    private let mockBehavior: MockBehavior?

    var httpMethod: TSCoreSDK.TSHttpMethod = .POST
    
    init(accessToken: String,  mockBehavior: MockBehavior? = nil) {
        self.accessToken = accessToken
        self.mockBehavior = mockBehavior
    }
    
    func urlHost() -> String? {
        "\(baseURL)\(path)"
    }
    
    func httpBody() -> Data? {
        let body = Body(autoStart: false, mockBehavior: mockBehavior)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let bodyData = try? encoder.encode(body)
        return bodyData
    }
    
    func headers() -> [String : String]? {
        return [HeadersKeys.contentType: "application/json", HeadersKeys.authorization: "Bearer \(accessToken)"]
    }
    
    func queriesParameters() -> TSCoreSDK.Parameters? {
        nil
    }
}
