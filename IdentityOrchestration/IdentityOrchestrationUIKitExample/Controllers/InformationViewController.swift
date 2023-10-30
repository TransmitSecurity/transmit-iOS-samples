//
//  InformationViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 18/09/2023.
//

import UIKit
import IdentityOrchestration


struct InformationViewInputData: Codable {
    let buttonText: String
    let title: String
    let text: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case buttonText = "button_text"
        case title
        case text
    }
}


class InformationViewController: BaseViewController {
    
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var data: InformationViewInputData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreensManager.shared.delegate = self
        setUpUI()
    }
    
    private func setUpUI() {
        self.messageTitle.text = data?.title ?? ""
        self.messageText.text = data?.text ?? ""
        self.continueButton.setTitle(data?.buttonText ?? "", for: .normal)
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        TSIdentityOrchestration.submitClientResponse(clientResponseOptionId: .clientInput)
    }
    
}

extension InformationViewController: ScreensManagerDelegate {
    
    func journeyViewDidChange(controller: UIViewController) {
        pushTo(vc: controller)
    }
    
}
