//
//  ScreensManager.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 18/09/2023.
//

import Foundation
import IdentityOrchestration
import TSCoreSDK
import UIKit


private enum JourneyStepId: String {
    
    case information
    
    case cryptoBindingRegistration = "crypto_binding_registration"
    
    case waitForAnotherDevice = "wait_for_ticket"
    
    case debugBreak = "debug_break"
    
    case rejection
    
    case phoneInput = "phone_input"
    
    case otpInput = "otp_input"
    
    case kbaInput = "kba_input"
    
    
    init?(idoStepId: IdentityOrchestration.IdoJourneyActionType) {
        switch idoStepId {
        case .information:
            self = .information
        case .cryptoBindingRegistration:
            self = .cryptoBindingRegistration
        case .debugBreak:
            self = .debugBreak
        case .waitForAnotherDevice:
            self = .waitForAnotherDevice
        default:
            if let customType = JourneyStepId(rawValue: idoStepId.description) {
                self = customType
            } else {
                return nil
            }
        }
    }
}

struct EscapeOption: ClientResponseOption {
    var type: IdentityOrchestration.ClientResponseOptionType
    
    var id: String
    
    var label: String
}


protocol ScreensManagerDelegate {
    func journeyViewDidChange(controller: UIViewController)
    func journeyViewDataDidChange(data: [String: Any])
}

extension ScreensManagerDelegate {
    func journeyViewDataDidChange(data: [String: Any]) {}
}

final class ScreensManager {
    
    static let shared: ScreensManager = .init()
    
    public var delegate: ScreensManagerDelegate? = nil
    
    private init() { }
        
    
}

extension ScreensManager {
    
    private func handleIdoResponse(_ response: IdentityOrchestration.IdoServiceResponse) {
        
        guard let actionData = response.data else { debugPrint("No data found in response object"); return }
        
        switch response.type {
        case .clientInputRequired:
            handleJourneyActionUI(for: response)
        case .clientInputUpdateRequired:
            handleJourneyViewDataDidChange(for: response)
        case .journeySuccess:
            handleJourneySuccess(for: actionData)
        case .journeyRejection:
            handleJourneyRejection(for: actionData)
        }
    }
    
    
    private func handleJourneyError(_ error: IdentityOrchestration.IdoJourneyError) {
        debugPrint("Journey error occured: \(error.localizedDescription)")
    }
}

// MARK: - handle journey action UI
private extension ScreensManager {
    
    private func handleJourneyActionUI(for response: IdentityOrchestration.IdoServiceResponse) {
        
        guard let responseStepId = response.journeyStepId else { debugPrint("No step id found in response"); return }
        
        guard let actionData = response.data else { debugPrint("No data found in response object"); return }
        
        let stepId = JourneyStepId.init(idoStepId: responseStepId)
        
        let responseOptions = response.clientResponseOptions?
            .compactMap { $0.value  }
            .filter { $0.type != .clientInput }
            .map { EscapeOption(type: $0.type, id: $0.id, label: $0.label) }

        var nextView: UIViewController?
        
        switch stepId {
        case .information:
            nextView = makeInformationView(withData: actionData)
            
        case .phoneInput:
            nextView = makePhoneInputView(withData: actionData, responseOptions: responseOptions)
            
        case .otpInput:
            nextView = makeOtpInputView(withData: actionData)
            
        case .kbaInput:
            nextView = makeKbaView(withData: actionData)
            
        case .cryptoBindingRegistration:
            nextView = makeCryptoBindingView(withData: actionData)
            
        case .waitForAnotherDevice:
            nextView = makeWaitForTicketView(withData: actionData)
            
        default:
            debugPrint("<<< Unsupported step! >>>")
            break
        }
        
        nextView.map { self.delegate?.journeyViewDidChange(controller: $0) }
        
    }

    private func handleJourneyViewDataDidChange(for response: IdentityOrchestration.IdoServiceResponse) {
        guard let actionData = response.data else { debugPrint("No data found in response object"); return }
        
        self.delegate?.journeyViewDataDidChange(data: actionData)
    }
    
    private func handleJourneyRejection(for actionData: [String: Any]) {
        let completionVC = makeJourneyCompletionView(withData: actionData, state: .rejected)
        self.delegate?.journeyViewDidChange(controller: completionVC)
    }
    
    private func handleJourneySuccess(for actionData: [String: Any]) {
        let completionVC = makeJourneyCompletionView(withData: actionData, state: .succeed)
        self.delegate?.journeyViewDidChange(controller: completionVC)
    }
}

// MARK: - screens creation
private extension ScreensManager {
    
    private func makeInformationView(withData actionData: [String: Any]) -> UIViewController {
        let data = actionData.decode(InformationViewInputData.self)
        let vc = NavigationManager.initiateViewControllerWith(identifier: .InformationViewController, storyboardName: .Main) as! InformationViewController
        vc.data = data
        return vc
    }
    
    private func makePhoneInputView(withData actionData: [String: Any], responseOptions: [EscapeOption]?) -> UIViewController {
        let vc = NavigationManager.initiateViewControllerWith(identifier: .PhoneFormViewController, storyboardName: .Main) as! PhoneFormViewController
        vc.escapeOptions = responseOptions
        vc.titleText = "Phone Form"
        return vc
    }
    
    private func makeOtpInputView(withData actionData: [String: Any]) -> UIViewController {
        let data = actionData.decode(OtpFormInputData.self)
        let vc = NavigationManager.initiateViewControllerWith(identifier: .OtpFormViewController, storyboardName: .Main) as! OtpFormViewController
        vc.data = data
        vc.titleText = "OTP Form"
        return vc
    }
    
    private func makeJourneyCompletionView(withData actionData: [String: Any], state: JourneyState) -> UIViewController {
        let data = actionData.decode(JourneyCompletionViewInputData.self)
        let vc = NavigationManager.initiateViewControllerWith(identifier: .JourneyCompleteViewController, storyboardName: .Main) as! JourneyCompleteViewController
        vc.state = state
        vc.data = data
        return vc
    }
    
    private func makeKbaView(withData actionData: [String: Any]) -> UIViewController {
        let data = actionData.decode(KbaFormInputData.self)
        let vc = NavigationManager.initiateViewControllerWith(identifier: .KbaViewController, storyboardName: .Main) as! KbaViewController
        vc.data = data
        return vc
    }
    
    private func makeCryptoBindingView(withData actionData: [String: Any]) -> UIViewController {
        let vc = NavigationManager.initiateViewControllerWith(identifier: .CryptoBindingViewController, storyboardName: .Main) as! CryptoBindingViewController
        vc.titleText = "Crypto Binding Form"
        return vc
    }
    
    private func makeWaitForTicketView(withData actionData: [String: Any]) -> UIViewController {
        let data = actionData.decode(WaitForTicketViewInputData.self)!
        let vc = NavigationManager.initiateViewControllerWith(identifier: .WaitForTicketViewController, storyboardName: .Main) as! WaitForTicketViewController
        vc.data = data
        return vc

    }
    
}

extension ScreensManager: TSIdentityOrchestrationDelegate {
    
    func identityOrchestrationDidReceiveResult(_ result: Result<IdentityOrchestration.IdoServiceResponse, IdentityOrchestration.IdoJourneyError>) {
        
        switch result {
        case .success(let response):
            handleIdoResponse(response)
        case .failure(let error):
            handleJourneyError(error)
        }
    }
    
    
}

//MARK: - start journey
extension ScreensManager {
    func startCurrentJourney(configuration: JourneyConfiguration) {
        TSIdentityOrchestration.startJourney(journeyId: configuration.journeyId.rawValue, options: configuration.options)
    }
    
    func startCrossDeviceJourney(messageId: String) {
        let configuration = IdoJourneyConfiguration.crossDevice(messageId: messageId)
        TSIdentityOrchestration.startJourney(journeyId: configuration.journeyId.rawValue, options: configuration.options)
    }
}
