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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = viewTitle ?? "SMS OTP Authentication"
        
        textLabel.text = viewDescription
    }
}
