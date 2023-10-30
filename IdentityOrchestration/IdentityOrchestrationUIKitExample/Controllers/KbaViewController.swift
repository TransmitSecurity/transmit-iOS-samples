//
//  KbaViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 19/09/2023.
//

import UIKit
import IdentityOrchestration

struct KbaFormInputData: Codable {
    let AppData: KbaAppData
    
    fileprivate enum CodingKeys: String, CodingKey {
        case AppData = "app_data"
    }
}

struct KbaAppData: Codable {
    let questions: [String]
    
    fileprivate enum CodingKeys: String, CodingKey {
        case questions
    }
}

class KbaViewController: BaseViewController {
    
    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var firstQuestion: UILabel!
    @IBOutlet weak var firstQuestionField: UITextField!
    @IBOutlet weak var secondQuestion: UILabel!
    @IBOutlet weak var secondQuestionField: UITextField!
    
    /// This demo journey has two question in this specific form, so for simplicity we access it directly without validate it
    var data: KbaFormInputData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ScreensManager.shared.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        self.firstQuestionField.layer.borderColor = UIColor.gray.cgColor
        self.firstQuestionField.layer.borderWidth = 1.0
        self.firstQuestionField.setCornerRadius(8.0)
        
        self.secondQuestionField.layer.borderColor = UIColor.gray.cgColor
        self.secondQuestionField.layer.borderWidth = 1.0
        self.secondQuestionField.setCornerRadius(8.0)
        
        self.formTitle.text = "KBA Form"
        
        if let questions = data?.AppData.questions {
            self.firstQuestion.text = questions[0]
            self.secondQuestion.text = questions[1]
        }
    }
    

    @IBAction func continueBtnClicked(_ sender: Any) {
        var kbaItems: [String: [[String: String]]] = [:]

        if let questions = data?.AppData.questions {
            let firstItem = ["question": questions[0],
                             "answer": firstQuestionField.text ?? ""]
            let secondItem = ["question": questions[1],
                              "answer": secondQuestionField.text ?? ""]
            
            kbaItems["kba"] = [firstItem, secondItem]
        }
        
        TSIdentityOrchestration.submitClientResponse(clientResponseOptionId: .clientInput, data: kbaItems)
    }
}

extension KbaViewController: ScreensManagerDelegate {
    
    func journeyViewDidChange(controller: UIViewController) {
        pushTo(vc: controller)
    }
    
}
