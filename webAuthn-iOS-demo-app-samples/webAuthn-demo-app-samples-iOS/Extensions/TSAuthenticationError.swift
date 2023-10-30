//
//  TSAuthenticationError.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import Foundation
import TSAuthenticationSDK

extension TSAuthenticationError {
   public var errorMessage: String {
        get {
            switch self {
            case .authenticationFailed:
                return "Authentication failed"
            case .registrationFailed:
                return "Registration failed"
            case .notInitialized:
                return "SDK is not initialized"
            case .genericServerError:
                return "Some generic server error"
            case .invalidWebAuthnSession:
                return "invalid WebAuthn session id"
            case .networkError:
                return "Seems like network error"
            case .requestIsRunning:
                return "request is already running"
            case .userNotFound:
                return "user not found"
            default:
                return "unknown"
            }
        }
    }
}

extension TSPasscodeError {
    public var passcodeMessage: String {
        get {
            switch self {
            case .canceled:
                return "Process canceled"
            case .invalidResponse:
                return "invalid response"
            case .notHandled:
                return "not handled"
            case .notInteractive:
                return "not interactive"
            default:
                return "Failed"
            }
        }
    }
}
