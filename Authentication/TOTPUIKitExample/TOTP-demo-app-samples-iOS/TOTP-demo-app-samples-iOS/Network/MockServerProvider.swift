//
//  MockServerProvider.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation
import TSCoreSDK
import TSAuthenticationSDK


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
    
    enum CompleteUserCreation: Error {
        case generic(TSRequestError)
    }
    
    enum CompleteNativeBiometricsRegistration: Error {
        case generic(TSRequestError)
    }
}

extension MockServerProvider {
    
    func getAccessToken(baseURL: String, clientId: String, clientSecret: String) async throws -> String {
        let accessTokenData = try await requestAccessToken(baseURL: baseURL, clientId: clientId, clientSecret: clientSecret)
        return accessTokenData.accessToken
    }

    func createUser(baseUrl: String, accessToken: String, user: TSUser) async throws -> TSCreateUserResponse {
        
        let request = TSCreateUserRequest(baseURL: baseUrl, accessToken: accessToken, user: user)
        
        return try await withCheckedThrowingContinuation { continuation in
            request.service.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.CompleteUserCreation.generic(error))
                }
            }
        }
    }
    
    func loginWithPassword(baseUrl: String, clientId: String, clientSecret: String, username: String, password: String) async throws -> TSLoginWithPasswordResponse {
        let request = TSLoginWithPasswordRequest(baseURL: baseUrl,
                                                 clientId: clientId,
                                                 clientSecret: clientSecret,
                                                 username: username,
                                                 password: password)
        
        return try await withCheckedThrowingContinuation { continuation in
            request.service.send(moduleInfo: DemoAppModuleInfo.shared) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.CompleteAuthentication.generic(error))
                }
            }
        }
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

}
