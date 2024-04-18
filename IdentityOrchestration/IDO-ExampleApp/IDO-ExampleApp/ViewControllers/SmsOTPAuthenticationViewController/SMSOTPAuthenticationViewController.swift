//
//  SMSOTPAuthenticationViewController.swift
//  IDO-ExampleApp
//
//  Created by Igor Babitski on 11/04/2024.
//

import UIKit
import IdentityOrchestration

class SMSOTPAuthenticationViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var otpInput: UITextField!
    
    override func viewDidLoad() {
        
        initializeIdoSDK()
        
        super.viewDidLoad()

        titleLabel.text = viewTitle ?? "SMS OTP Authentication"
        
        textLabel.text = viewDescription
    }
    
    override func submitButtonTapped() {
        guard let passcode = otpInput.text, !passcode.isEmpty else {
            showAlert(title: "Incorrect OTP passcode", message: "The passcode should be a non-empty, numeric string.")
            return
        }
        
        super.submitButtonTapped()
        
        TSIdo.submitClientResponse(clientResponseOptionId: .clientInput, data: ["passcode": passcode])
    }
    
    func initializeIdoSDK() {
        do {
            try TSIdo.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "IDO SDK Initialization Error", message: "\(error)")
        }
    }
}
