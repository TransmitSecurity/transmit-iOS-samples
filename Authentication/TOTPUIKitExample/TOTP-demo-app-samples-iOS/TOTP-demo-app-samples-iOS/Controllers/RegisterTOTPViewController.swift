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
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var switcher: UISwitch!
    
    var URI: String = ""
    weak var delegate: RegisterTOTPDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.setCornerRadius(12.0)
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
    
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        TSAuthentication.shared.registerTOTP(URI: URI, securityType: switcher.isOn ? .biometric : .none) { [weak self] result in
            guard let self else { return }
            self.completeTOTPRegistrationProcess(with: result, securityType: self.switcher.isOn ? .biometric : .none)
        }
    }
    
}
