//
//  ProcessStatus.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import Foundation
import Combine

final class ProcessStatus: ObservableObject {
    var status: CurrentValueSubject<ProcessState,Never> = .init(.processing)
    
    static let shared = ProcessStatus()
    private init() {}
}

enum ReccomendationType {
    case ALLOW
    case DENY
    case CHALLENGE
    case unknown
    
    init?(rawValue: String?) {
        switch rawValue {
        case "ALLOW":
            self = .ALLOW
        case "DENY":
            self = .DENY
        case "CHALLENGE":
            self = .CHALLENGE
        default:
            self = .unknown
        }
    }
}


enum ProcessState: Equatable {
    case initialize
    case processing
    case completed(ReccomendationType, String)
    case registrationFailed(String)
    case autenticateFailed(String)
    
    var title: String {
        get {
            switch self {
            case .processing:
                return "in progress"
            case .completed:
                return "Process Complete"
            case .registrationFailed:
                return "Registration failed"
            case .autenticateFailed:
                return "Autenticate failed"
            default:
                return ""
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .processing:
                return "in progress"
            case .completed(let type, let reasons):
                return "Reccomendation is: \(type)\n\(reasons)"
            case .registrationFailed(let error):
                return "Registration failed, error: \(error)"
            case .autenticateFailed(let error):
                return "Autenticate failed, error: \(error)"
            default:
                return ""
            }
        }
    }
    
    var icon: String {
        get {
            switch self {
            case .processing:
                return ""
            case .completed:
                return "ic_completed"
            case .registrationFailed, .autenticateFailed:
                return "ic_general_error"
            default:
                return ""
            }
        }
    }
    
    var buttonDescription: String {
      return "Back to main screen"
    }
    
}
