//
//  VerificationProcessView.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI
import IdentityVerification

struct VerificationProcessView: View {
    @ObservedObject var viewModel: VerificationProcessViewModel
    @Environment(\.presentationMode) private var presentation

    var body: some View {
        VStack {
            Constants.Icons.logo
            stateView(state: viewModel.state)
            Spacer()
            Button(action: { handleStateButtonClicked() }) {
                Text(viewModel.state.buttonDescription)
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: Constants.Colors.primaryBlue))
            .hidden(viewModel.state.shouldHideButton)
        }
        .padding([.top,.bottom], 45)
        .padding([.leading, .trailing], 38)
        .background(Color.white)
    }
}

struct VerificationProcessStateView: View {
    @Binding var state: VerificationProcessState
    
    var body: some View {
        VStack {
            Text(state.title).font(Font.custom(Constants.Fonts.Inter.semiBold, size: 24)).foregroundColor(Color.black).multilineTextAlignment(.center)
                .padding([.trailing, .leading], 15)
            VStack(spacing: 38) {
                if state == .processing {
                    LoaderView(tintColor: .gray, scaleSize: 3.0)
                } else {
                    Image(state.icon)
                }
                Text(state.description).font(Font.custom(Constants.Fonts.Inter.regular, size: 16)).foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
            }.padding(.top, 72)
            .padding([.trailing, .leading], 30)
        }
        .padding(.top, 75)
    }
}

extension VerificationProcessView {
    private func handleStateButtonClicked() {
        switch viewModel.state {
        case .cameraPermissionError:
          openSettings()
        case .completed:
            navigate()
        case .recapture:
            viewModel.recapture()
        default:
            return
        }
    }
    
    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func navigate() {
        VerificationProcessStatus.shared.status.send(.initialize)
        presentation.wrappedValue.dismiss()
    }
    
    @ViewBuilder private func stateView(state: VerificationProcessState) -> some View {
        switch state {
        case .initialize,. processing, .completed, .cameraPermissionError, .generalError:
            VerificationProcessStateView(state: $viewModel.state)
        case .recapture(let state):
            VerificationProcessResubmitView(state: state)
        }
    }
}


struct VerificationProcessView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationProcessView(viewModel: VerificationProcessViewModel())
    }
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
                return "Try again"
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
    
    var listData: [GenericListViewData] {
        get {
            switch self {
            case .imageMissing, .poorImageQuality:
                return [GenericListViewData(title: "Capture of document and selfie is clear", icon: "ic_visible"),
                    GenericListViewData(title: "Take back capture (instead of front)", icon: "id_card"),
                    GenericListViewData(title: "Selfie is in frame", icon: "ic_selfie")]
            case .docExpired, .docNotSupported, .docDamaged:                return [GenericListViewData(title: "Passport", icon: "ic_document_checked"),
                    GenericListViewData(title: "Driver licence", icon: "ic_document_checked"),
                    GenericListViewData(title: "National ID", icon: "ic_document_checked")]
            @unknown default:
                return [GenericListViewData(title: "Passport", icon: "ic_document_checked"),
                        GenericListViewData(title: "Driver licence", icon: "ic_document_checked"),
                        GenericListViewData(title: "National ID", icon: "ic_document_checked")]
            }
        }
    }
}
