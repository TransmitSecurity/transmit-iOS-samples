//
//  PhoneFormViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 18/09/2023.
//

import UIKit
import IdentityOrchestration


class PhoneFormViewController: BaseViewController {

    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var formInputField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var titleText: String?
    
    /// This demo journey has only one escape option, so for simplicity, we can confidently use it and access it
    var escapeOptions: [EscapeOption]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreensManager.shared.delegate = self
        setupUI()
    }
    

    private func setupUI() {
        self.formInputField.layer.borderColor = UIColor.gray.cgColor
        self.formInputField.layer.borderWidth = 1.0
        self.formInputField.setCornerRadius(8.0)
        self.formTitle.text = titleText ?? "Phone Form"
        self.infoButton.setTitle(escapeOptions?.first?.label ?? "info", for: .normal)
    }

    @IBAction func continueButtonClicked(_ sender: Any) {
        let outputData = ["phone": formInputField.text ?? ""]
        TSIdentityOrchestration.submitClientResponse(clientResponseOptionId: .clientInput, data: outputData)
    }
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        let outputData = ["phone": formInputField.text ?? ""]
        let customOption: ClientResponseOptionType = .custom(id: escapeOptions?.first?.id ?? "1")
        TSIdentityOrchestration.submitClientResponse(clientResponseOptionId: customOption, data: outputData)
    }
    
}


extension PhoneFormViewController: ScreensManagerDelegate {
    
    func journeyViewDidChange(controller: UIViewController) {
        pushTo(vc: controller)
    }
    
}
