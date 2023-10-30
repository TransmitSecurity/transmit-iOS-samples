//
//  VerificationProcessStatus.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI
import Combine
import IdentityVerification

final class VerificationProcessStatus: ObservableObject {
    var status: CurrentValueSubject<VerificationProcessState,Never> = .init(.initialize)
    
    static let shared = VerificationProcessStatus()
    private init() {}
}

enum VerificationProcessState: Equatable {
    case initialize
    case processing
    case completed
    case cameraPermissionError
    case generalError
    case recapture(TSRecaptureReason)
    
    
    var title: String {
        get {
            switch self {
            case .processing:
                return "Verification in progress"
            case .completed:
                return "Verification Complete"
            case .cameraPermissionError:
                return "Camera permissions required"
            case .generalError:
                return "Something wen’t wrong"
            default:
                return ""
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .processing:
                return "Please wait"
            case .completed:
                return ""
            case .cameraPermissionError:
                return "Enable camera permissions in the device app settings and try again"
            case .generalError:
                return "Please go back and restart the verification process"
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
            case .cameraPermissionError:
                return "ic_camera_permission_missing"
            case .generalError:
                return "ic_general_error"
            default:
                return ""
            }
        }
    }
    
    var buttonDescription: String {
        get {
            switch self {
            case .completed:
                return "New verification"
            case .cameraPermissionError:
                return "Application Settings"
            case .recapture:
                return "Retry"
            default:
                return ""
            }
        }
    }
    
    var shouldHideButton: Bool {
        get {
            switch self {
            case .processing, .generalError:
                return true
            case .completed, .cameraPermissionError, .recapture:
                return false
            default:
                return true
            }
        }
    }
}

extension TSRecaptureReason {
    var title: String {
        get {
            switch self {
            case .imageMissing, .poorImageQuality:
                return "Please try again"
            case .docExpired:
                return "Document expired"
            case .docNotSupported:
                return "Unsupported Document"
            case .docDamaged:
                return "Document damaged"
            @unknown default:
                return "Unidentified ID"
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .imageMissing, .poorImageQuality:
                return "Make sure you capture a valid document and selfie and try again"
            case .docExpired, .docNotSupported, .docDamaged:
                return "Please use another government issue ID"
            @unknown default:
                return "Please use another government issue ID"
            }
        }
    }
    
    var subDescription: String {
        get {
            switch self {
            case .imageMissing, .poorImageQuality:
                return ""
            case .docExpired, .docNotSupported, .docDamaged:
                return "We support these document types"
            @unknown default:
                return ""
            }
        }
    }
    
    var listData: [GenericTableViewCellModel] {
        get {
            switch self {
            case .imageMissing, .poorImageQuality:
                return [GenericTableViewCellModel(title: "Capture of document and selfie is clear", icon: "ic_visible"),
                        GenericTableViewCellModel(title: "Take back capture (instead of front)", icon: "id-card"),
                        GenericTableViewCellModel(title: "Selfie is in frame", icon: "ic_selfie")]
            case .docExpired, .docNotSupported, .docDamaged:
                return [GenericTableViewCellModel(title: "Passport", icon: "ic_document_checked"),
                        GenericTableViewCellModel(title: "Driver licence", icon: "ic_document_checked"),
                        GenericTableViewCellModel(title: "National ID", icon: "ic_document_checked")]
            @unknown default:
                return [GenericTableViewCellModel(title: "Passport", icon: "ic_document_checked"),
                        GenericTableViewCellModel(title: "Driver licence", icon: "ic_document_checked"),
                        GenericTableViewCellModel(title: "National ID", icon: "ic_document_checked")]
            }
        }
    }
}
