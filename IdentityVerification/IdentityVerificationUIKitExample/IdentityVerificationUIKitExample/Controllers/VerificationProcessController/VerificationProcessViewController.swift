//
//  VerificationProcessViewController.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit
import Combine
import IdentityVerification

class VerificationProcessViewController: UIViewController {
    
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var continueButton: CustomButtonView!
    @IBOutlet weak var resubmitView: ResubmitView!
    private var state: VerificationProcessState? = nil
    private var anyCancellable: AnyCancellable? = nil
    var sessionID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.state = VerificationProcessStatus.shared.status.value
        observeVerificationProcessState()
        continueButton.initView(isEnable: true, buttonText: self.state?.buttonDescription ?? "", listener: self)
    }
    
    private func setupUI() {
        switch self.state {
        case .processing, .completed, .cameraPermissionError, .generalError, .initialize, .none:
            progressView.initView(title: state?.title, description: state?.description, imageName: state?.icon, showLoader: state == .processing ? true : false)
            progressView.isHidden = false
            resubmitView.isHidden = true
        case .recapture(let reason):
            resubmitView.initView(title: reason.title, description: reason.description, subDescription: reason.subDescription, documentData: reason.listData)
            progressView.isHidden = true
            resubmitView.isHidden = false
        }
        toggleButtonState()
    }
    
    private func toggleButtonState() {
        continueButton.isHidden = self.state?.shouldHideButton ?? true
        continueButton.updateButtonText(buttonText: self.state?.buttonDescription ?? "")
    }
    
    private func observeVerificationProcessState() {
        anyCancellable = VerificationProcessStatus.shared.status.sink { [self] status in
            self.state = status
            self.handleUpadtes()
        }
    }
    
    private func handleUpadtes() {
        setupUI()
        guard state == .completed else { return }
        getVerificationResult()
    }
    
    private func handleStateButtonClicked() {
        switch self.state {
        case .cameraPermissionError:
            openSettings()
        case .completed:
            popScreen()
        case .recapture:
            TSIdentityVerification.recapture()
        default:
            return
        }
    }
    
    private func popScreen() {
        VerificationProcessStatus.shared.status.send(.initialize)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func getVerificationResult() {
        Task {
            guard let sessionID = self.sessionID else { return }
            let verficationResult = try await MockServerProvider.shared.getVerfication(clientId: Constants.App.clientId, clientSecret: Constants.App.clientSecret, sessionID: sessionID)
            debugPrint("verfication result:", verficationResult.recommendation, verficationResult.status)
        }
    }

}

extension VerificationProcessViewController: CustomButtonViewDelegate {
    func clicked() {
        handleStateButtonClicked()
    }
}
