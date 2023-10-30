//
//  CryptoBindingViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 20/09/2023.
//

import UIKit
import IdentityOrchestration

class CryptoBindingViewController: BaseViewController {
    
    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    enum State {
        case initial
        
        case loading
        
        case finished
    }
    
    
    var state: State = .initial {
        didSet {
            handleStateDidChange()
        }
    }
    
    var titleText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScreensManager.shared.delegate = self
        setupUI()
        self.state = .initial
    }
    

    private func setupUI() {
        formTitle.text = titleText
    }
    
    func goToNextStep() {
        
        switch state {
        case .initial:
            state = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.state = .finished
            }
        case .finished:
            state = .finished
            TSIdentityOrchestration.submitClientResponse(clientResponseOptionId: .clientInput, data: [:])
        case .loading:
            break
        }
    }
    
    private func handleStateDidChange() {
        switch state {
        case .initial:
            self.submitButton.setTitle("Generate public key", for: .normal)
        case .loading:
            showLoader()
            self.submitButton.setTitle("Generate public key", for: .normal)
        case .finished:
            hideLoader()
            self.submitButton.setTitle("Countinue", for: .normal)
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        goToNextStep()
    }
    
}

extension CryptoBindingViewController: ScreensManagerDelegate {
    
    func journeyViewDidChange(controller: UIViewController) {
        pushTo(vc: controller)
    }
    
}
