//
//  MainViewModel.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import Foundation
import SwiftUI
import TSAuthenticationSDK
import AccountProtection
import TSCoreSDK

struct DRSError {
    
}

extension DRSError {
    enum TriggerAction: Error {
        case generic(String)
    }
}

class MainViewModel: ObservableObject {
    
    @Published var moveToRecommendationView = false

    var state: ProcessState? = nil {
        didSet {
            DispatchQueue.main.async {
                self.moveToRecommendationView = true
            }
        }
    }
    
    enum CurrentProcess {
        case authenticate
        case registration
    }
    
    private func startRegistrationSession(_ username: String) {
        Task {
            do {
                let actionToken = try await triggerAction(action: "register")
                TSAuthentication.shared.register(username: username, displayName: username) { respone in
                    switch respone {
                    case .success(let result):
                        self.completeRegistration(webauthnEncodedResult: result.result, username: username, actionToken: actionToken)
                    case .failure(let error):
                        self.handleError(error: error, state: .registration)
                    }
                }
            } catch(let error) {
                debugPrint(error.localizedDescription)
            }
 
        }
    }
    
    private func startAuthenticationProcess(_ username: String) {
        Task {
            do {
                let actionToken = try await triggerAction(action: "login")
                TSAuthentication.shared.authenticate(username: username) { respone in
                    switch respone {
                    case .success(let result):
                        self.completeAuthentication(webauthnEncodedResult: result.result, username: username, actionToken: actionToken)
                    case .failure(let error):
                        self.handleError(error: error, state: .authenticate)
                    }
                }
            } catch(let error) {
                debugPrint(error.localizedDescription)
            }

        }
    }
    
    private func triggerAction(action: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            TSAccountProtection.triggerAction(action) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.actionToken)
                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case .disabled:
                        errorMessage = "Action is Disabled"
                    case .connectionError:
                        errorMessage = "Connection Error"
                    case .internalError:
                        errorMessage = "Internal Error"
                    case .notSupportedActionError:
                        errorMessage = "LOGIN ACTION IS NOT SUPPORTED"
                    @unknown default:
                        errorMessage = "Unknown Error"
                    }
                    continuation.resume(throwing: DRSError.TriggerAction.generic(errorMessage))
                }
            }
        }
    }
    
    private func handleError(error: TSAuthenticationError, state: CurrentProcess) {
        switch error {
        case .passkeyError(let passkeyError):
            handlePasskeyError(error: passkeyError)
        default:
            handleAuthenticationError(error: error, state: state)
        }
    }
    
    private func handlePasskeyError(error: TSPasscodeError) {
//        showErrorToast(error: error.passcodeMessage)
    }
    
    private func handleAuthenticationError(error: TSAuthenticationError, state: CurrentProcess) {
        self.state = .processing
        switch state {
        case .authenticate:
            ProcessStatus.shared.status.send(.autenticateFailed(error.errorMessage))
        case .registration:
            ProcessStatus.shared.status.send(.registrationFailed(error.errorMessage))
        }
    }

    private func getAccessToken() async throws -> String? {
        return try await MockServerProvider.shared.getAccessToken(baseURL: Constants.Network.baseUrl, clientId: Constants.App.clientId, clientSecret: Constants.App.clientSecret)
    }
    
    private func completeRegistration(webauthnEncodedResult: String, username: String, actionToken: String) {
        ProcessStatus.shared.status.send(.processing)
        state = .processing
        Task {
            do {
                guard let accessToken = try await getAccessToken() else { return }
                _ = try await MockServerProvider.shared.completeRegistration(baseURL: Constants.Network.baseUrl, accessToken: accessToken, webAuthnEncodedResult: webauthnEncodedResult, externalUserId: "\(username)-test)", externalUserIdentifier: "\(username)-test)")
                let response = try await MockServerProvider.shared.getReccomendation(accessToken: accessToken, actionToken: actionToken)
                if let type = ReccomendationType(rawValue: response.recommendation?.type), let reasons = response.reasons {
                    let reasonsText = reasons.count > 0 ? "Reasons are: \(reasons.joined(separator: ", "))" : ""
                    ProcessStatus.shared.status.send(.completed(type, reasonsText))
                    return
                }
                ProcessStatus.shared.status.send(.completed(.unknown, ""))
            } catch let error {
                ProcessStatus.shared.status.send(.registrationFailed(error.localizedDescription))
            }
        }
    }

    private func completeAuthentication(webauthnEncodedResult: String, username: String, actionToken: String) {
        ProcessStatus.shared.status.send(.processing)
        state = .processing
        Task {
            do {
                guard let accessToken = try await getAccessToken() else { return }
                _ = try await MockServerProvider.shared.completeAuthentication(baseURL: Constants.Network.baseUrl, accessToken: accessToken, webAuthnEncodedResult: webauthnEncodedResult)
                let response = try await MockServerProvider.shared.getReccomendation(accessToken: accessToken, actionToken: actionToken)
                if let type = ReccomendationType(rawValue: response.recommendation?.type), let reasons = response.reasons {
                    let reasonsText = reasons.count > 0 ? "Reasons are: \(reasons.joined(separator: ", "))" : ""
                    ProcessStatus.shared.status.send(.completed(type, reasonsText))
                    return
                }
                ProcessStatus.shared.status.send(.completed(.unknown, ""))
            } catch let error {
                ProcessStatus.shared.status.send(.autenticateFailed(error.localizedDescription))
            }
        }
    }
        
    public func registerButtonClicked(_ username: String) {
        SdkController.shared.initializeWebAuthnSDK()
        
        startRegistrationSession(username)
    }
    
    public func loginButtonClicked(_ username: String) {
        SdkController.shared.initializeWebAuthnSDK()
        
        startAuthenticationProcess(username)
    }
    
    public func nextFlowView() -> AnyView {
        return AnyView(RecommendationView(viewModel: RecommendationViewModel()))
    }
}
