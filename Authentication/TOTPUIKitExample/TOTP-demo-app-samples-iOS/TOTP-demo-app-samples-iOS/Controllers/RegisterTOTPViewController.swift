//
//  RegisterTOTPViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import UIKit
import TSAuthenticationSDK

protocol RegisterTOTPDelegate: AnyObject {
    func didRecieveTOTPInfo(_ totpInfo: DataManager.TOTPInfo?)
}

class RegisterTOTPViewController: UIViewController {
    
    var URI: String = ""
    weak var delegate: RegisterTOTPDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerWithBiometricBtnClicked(_ sender: Any) {
        TSAuthentication.shared.registerTOTP(URI: URI, securityType: .biometric) { [weak self] result in
            self?.completeTOTPRegistrationProcess(with: result, securityType: .biometric)
        }
    }
    
    
    @IBAction func registerWithoutBiometricBtnClicked(_ sender: Any) {
        TSAuthentication.shared.registerTOTP(URI: URI, securityType: .none) { [weak self] result in
            self?.completeTOTPRegistrationProcess(with: result, securityType: .none)
        }
    }
    
    
    private func completeTOTPRegistrationProcess(with result: Result<TSTOTPRegistrationResult, TSAuthenticationError>, securityType: TSTOTPSecurityType) {
        switch result {
        case .success(let response):
            
            let totpInfo: DataManager.TOTPInfo = .init(issuer: response.issuer ?? "", label: response.label ?? "", uuid: response.uuid, biometric: securityType == .biometric ? true : false)
            
            self.delegate?.didRecieveTOTPInfo(totpInfo)
            
            self.dismissViewController()
            
        case .failure(let error):
            debugPrint("failure")
        }
    }
    
    
    private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
}
