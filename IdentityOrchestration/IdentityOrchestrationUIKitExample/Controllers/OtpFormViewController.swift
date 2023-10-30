//
//  OtpFormViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 18/09/2023.
//

import UIKit
import IdentityOrchestration

struct OtpFormInputData: Codable {
    let AppData: AppData
    
    fileprivate enum CodingKeys: String, CodingKey {
        case AppData = "app_data"
    }
}

struct AppData: Codable {
    let message: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}


class OtpFormViewController: BaseViewController {

    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var otpMessage: UILabel!
    
    var titleText: String?
    var data: OtpFormInputData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreensManager.shared.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        self.codeField.layer.borderColor = UIColor.gray.cgColor
        self.codeField.layer.borderWidth = 1.0
        self.codeField.setCornerRadius(8.0)
        self.formTitle.text = titleText ?? "Phone Form"
        self.otpMessage.text = data?.AppData.message ?? "otp"
    }
    
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        let outputData = ["otp": codeField.text ?? ""]
        TSIdentityOrchestration.submitClientResponse(clientResponseOptionId: .clientInput, data: outputData)
    }
    
}

extension OtpFormViewController: ScreensManagerDelegate {
    
    func journeyViewDidChange(controller: UIViewController) {
        pushTo(vc: controller)
    }
    
}
