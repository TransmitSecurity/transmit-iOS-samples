//
//  LoginViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        loginBtn.setCornerRadius(12.0)
        registerBtn.setCornerRadius(12.0)
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        emailTextField.delegate = self
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    

    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func RegisterBtnClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
