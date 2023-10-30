//
//  JourneySuccessViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 19/09/2023.
//

import UIKit

enum JourneyState {
    
    case succeed
    
    case rejected
    
    var description: String {
        switch self {
        case .succeed:
            return "Journey succeed"
        case .rejected:
            return "Journey rejected"
        }
    }
    
    var icon: String {
        switch self {
        case .succeed:
            return "circle-check-success"
        case .rejected:
            return "circle-check-failure"
        }
    }
}

struct RejectionData: Codable {
    
    let text: String?
    
    let buttonText: String?
    
    let type: String?
    
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case buttonText = "button_text"
        case type
        case title
    }
}

struct FailureData: Codable {
    
    let source: Source?
    
    let reason: Reason?
    
    enum CodingKeys: String, CodingKey {
        case source
        case reason
    }
}


struct Reason: Codable {
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case type
    }
}

struct Source: Codable {
    let actionType: String?
    
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case actionType = "action_type"
        case type
    }
}


struct JourneyCompletionViewInputData: Codable {
    
    let rejectionData: RejectionData?
    
    let failureData: FailureData?
    

    enum CodingKeys: String, CodingKey {
        case rejectionData = "rejection_data"
        case failureData = "failure_data"
    }
}

class JourneyCompleteViewController: BaseViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    
    var data: JourneyCompletionViewInputData?
    var state: JourneyState = .succeed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    private func setupUI() {
        self.icon.image = UIImage(named: state.icon)
        self.message.text = state.description
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
