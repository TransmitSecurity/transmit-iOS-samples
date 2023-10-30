//
//  MockServerProvider.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//


import Foundation
import TSCoreSDK

class MockServerProvider {
    static let shared: MockServerProvider = MockServerProvider()
    
    private init() { }
    
}

struct NetworkError {
    
}

extension NetworkError {
    enum AccessToken: Error {
        case generic(TSRequestError)
    }
}

extension NetworkError {
    enum CompleteRegistration: Error {
        case generic(TSRequestError)
    }
    
    enum CompleteAuthentication: Error {
        case generic(TSRequestError)
    }
    
    enum GetReccomendation: Error {
        case generic(TSRequestError)
    }
}

extension MockServerProvider {
    
    func getAccessToken(baseURL: String, clientId: String, clientSecret: String) async throws -> String {
        let accessTokenData = try await requestAccessToken(baseURL: baseURL, clientId: clientId, clientSecret: clientSecret)
        return accessTokenData.accessToken
    }
    
    func completeRegistration(baseURL: String, accessToken: String, webAuthnEncodedResult: String, externalUserId : String, externalUserIdentifier: String) async throws -> TSCompleteRegistrationResponseData {
        let registrationData = try await requestCompleteRegistration(baseURL: baseURL, accessToken: accessToken, webAuthnEncodedResult: webAuthnEncodedResult, externalUserId: externalUserId, externalUserIdentifier: externalUserIdentifier)
        
        return registrationData
    }
    
    func completeAuthentication(baseURL: String, accessToken: String, webAuthnEncodedResult: String) async throws -> TSCompleteAuthenticationResponseData {
        let authenticationData = try await requestCompleteAuthentication(baseURL: baseURL, accessToken: accessToken, webauthnEncodedResult: webAuthnEncodedResult)
        
        return authenticationData
    }
    
    func getReccomendation(accessToken: String, actionToken: String) async throws -> TSGetReccomendationResponse {
        let reccomendationData = try await requestGetReccomendation(accessToken: accessToken, actionToken: actionToken)
        
        return reccomendationData
    }

}

// MARK: - private API
private extension MockServerProvider {
    
    private func requestAccessToken(baseURL: String, clientId: String, clientSecret: String) async throws -> GetAccessTokenResponse {
        let request = GetAccessTokenRequest(baseURL: baseURL, clientId: clientId, clientSecret: clientSecret)
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
    
    
    private func requestCompleteRegistration(baseURL: String, accessToken: String, webAuthnEncodedResult: String, externalUserId : String, externalUserIdentifier: String) async throws -> TSCompleteRegistrationResponseData {
        let request = TSCompleteRegistrationRequest(baseURL: baseURL, accessToken: accessToken, webauthnEncodedResult: webAuthnEncodedResult, externalUserId: externalUserId, externalUserIdentifier: externalUserIdentifier)
        let requestService = TSNetworkService<TSCompleteRegistrationRequest, TSCompleteRegistrationResponseData>(request: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            requestService.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.CompleteRegistration.generic(error))
                }
            }
        }
    }
    
    
    private func requestCompleteAuthentication(baseURL: String, accessToken: String, webauthnEncodedResult: String) async throws -> TSCompleteAuthenticationResponseData {
        let request = TSCompleteAuthenticationRequest(baseURL: baseURL, accessToken: accessToken, webauthnEncodedResult: webauthnEncodedResult)
        let requestService = TSNetworkService<TSCompleteAuthenticationRequest, TSCompleteAuthenticationResponseData>(request: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            requestService.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.CompleteAuthentication.generic(error))
                }
            }
        }
    }
    
    private func requestGetReccomendation(accessToken: String, actionToken: String) async throws -> TSGetReccomendationResponse {
        let request = TSGetReccomendationRequest(accessToken: accessToken, actionToken: actionToken)
        let requestService = TSNetworkService<TSGetReccomendationRequest, TSGetReccomendationResponse>(request: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            requestService.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.GetReccomendation.generic(error))
                }
            }
        }
    }

}
