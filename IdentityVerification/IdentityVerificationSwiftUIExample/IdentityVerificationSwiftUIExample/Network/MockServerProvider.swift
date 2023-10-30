//
//  NetworkManager.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import TSCoreSDK

struct NetworkError {
    
}

extension NetworkError {
    enum AccessToken: Error {
        case generic(TSRequestError)
    }
}

extension NetworkError {
    enum CreateSession: Error {
        case generic(TSRequestError)
    }
}

/**
 IMPORTANT: Mock Server Provider Class Usage Notice

 Please note that the "MockServerProvider" class included in this sample app serves as a demonstration tool and should not be used in a production environment. This class has been created to simulate server-side functionality for showcasing the usage of the SDK.

 In a production environment, the app's server should be responsible for handling the communication between the app and Transmit's server. The app's server acts as an intermediary, facilitating secure and optimized communication with our server, which provides the actual SDK functionality.

 When integrating the SDK into your own application, it is essential to adhere to the recommended communication flow. Your app's server should handle the communication with Transmit's server.
 */

class MockServerProvider {
    static let shared: MockServerProvider = MockServerProvider()
    
    private init() { }
    
    func createSession(clientId: String, clientSecret: String, mockBehavior: CreateSessionRequest.MockBehavior? = nil) async throws -> CreateSessionResponse {
        let accessTokenData = try await requestAccessToken(clientId: clientId, clientSecret: clientSecret)

        let sessionData = try await requestCreateSession(accessToken: accessTokenData.accessToken, mockBehavior: mockBehavior)
        
        return sessionData
    }
    
    func getVerfication(clientId: String, clientSecret: String, sessionID: String) async throws -> GetVerficiationResponse {
        let accessTokenData = try await requestAccessToken(clientId: clientId, clientSecret: clientSecret)

        let verficationData = try await requestGetVerfication(sessionID: sessionID, accessToken: accessTokenData.accessToken)
        
        return verficationData
    }
    
    
    private func requestAccessToken(clientId: String, clientSecret: String) async throws -> GetAccessTokenResponse {
        let request = GetAccessTokenRequest(clientId: clientId, clientSecret: clientSecret)
        let requestService = TSNetworkService<GetAccessTokenRequest, GetAccessTokenResponse>(request: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            requestService.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.AccessToken.generic(error))
                }
            }
        }
    }
    
    private func requestCreateSession(accessToken: String, mockBehavior: CreateSessionRequest.MockBehavior? = nil) async throws -> CreateSessionResponse {
        let request = CreateSessionRequest(accessToken: accessToken, mockBehavior: mockBehavior)
        let requestService = TSNetworkService<CreateSessionRequest, CreateSessionResponse>(request: request)

        return try await withCheckedThrowingContinuation { continuation in
            requestService.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.CreateSession.generic(error))
                }
            }
        }
    }
    
    func requestGetVerfication(sessionID: String, accessToken: String) async throws -> GetVerficiationResponse {
        
        let request = GetVerficiationRequest(sessionID: sessionID, accessToken: accessToken)
        let requestService = TSNetworkService<GetVerficiationRequest, GetVerficiationResponse>(request: request)

        return try await withCheckedThrowingContinuation { continuation in
            requestService.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.CreateSession.generic(error))
                }
            }
        }
    }

}
