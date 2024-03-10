//
//  LoginViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import UIKit
import TSAuthenticationSDK

class LoginViewController: TSXBaseViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userDetailsStackView: UIStackView!
    
    enum RegistrationError: Error {
        case userAlreadyRegistred
        
        case auth(TSAuthenticationError)
    }
    
    enum UserAuthState {
        case loggedIn
        
        case loggedOut
    }
    
    private var currentAuthState: UserAuthState = .loggedOut {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setInitialUserState()
    }
    
    private func setupUI() {
        loginBtn.setCornerRadius(12.0)
        registerBtn.setCornerRadius(12.0)
        continueBtn.setCornerRadius(12.0)
        
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
        
        closeBtn.setTitle("", for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func updateUI() {
        
        switch currentAuthState {
        case .loggedIn:
            greetingLabel.text = "Your logged in as:"
            userLabel.text = DataManager.shared.loggedInUsername
            userDetailsStackView.isHidden = true
            registerBtn.isHidden = true
            loginBtn.isHidden = true
            logoutBtn.isHidden = false
            continueBtn.isHidden = false
        case .loggedOut:
            greetingLabel.text = "Logged Out"
            userLabel.text = ""
            userDetailsStackView.isHidden = false
            registerBtn.isHidden = false
            loginBtn.isHidden = false
            logoutBtn.isHidden = true
            continueBtn.isHidden = true
        }
    }

    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        guard currentAuthState == .loggedOut else  { return }
                
        loginUser()
    }
    
    @IBAction func RegisterBtnClicked(_ sender: Any) {
        registerUser()
    }
    
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        logOutCurrentUser()
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        pushToSilentTOTPVC()
    }
    
}

private extension LoginViewController {
    
    
    private func setInitialUserState() {
        currentAuthState = DataManager.shared.isUserLoggedIn() ? .loggedIn : .loggedOut
    }
    
    private func logInUser(username: String, password: String) {
        Task {
            do {
                let resposne = try await loginWithPassword(username: username, password: password)
                
                let loginInfo = DataManager.LoginInfo(username: username, password: password, userToken: resposne.accessToken)
                
                DataManager.shared.saveLoginInfo(loginInfo)

                currentAuthState = .loggedIn
                
                hideLoader()
            } catch {
                handleUserLoginError(error)
                hideLoader()
            }
        }
    }
    
    private func registerUser(username: String?, email: String, password: String) {
        Task {
            do {
                showLoader()
                let _ = try await createUser(username: username, email: email, password: password)
            
                logInUser(username: email, password: password)
            } catch {
                handleUserRegistrationError(error)
                hideLoader()
            }
        }
    }
    
    private func createUser(username: String?, email: String, password: String) async throws -> TSCreateUserResponse {
        let baseUrl = Constants.Network.baseUrl
        let mockUser = TSUser.makeMockUser(username: username, email: email, password: password)
        
        let accessToken = try await getAccessToken()
        
        return try await MockServerProvider.shared.createUser(baseUrl: baseUrl,
                                                              accessToken: accessToken,
                                                              user: mockUser)
    }
    
    private func loginWithPassword(username: String, password: String) async throws -> TSLoginWithPasswordResponse {
        let baseUrl = Constants.Network.baseUrl
        let clientId = Constants.App.clientId
        let secret = Constants.App.clientSecret
        
        return try await MockServerProvider.shared.loginWithPassword(baseUrl: baseUrl,
                                                                     clientId: clientId,
                                                                     clientSecret: secret,
                                                                     username: username,
                                                                     password: password)
    }
    
    
    private func registerUser() {
        guard let username = emailTextField.text, !username.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
            showToast(message: "Username or password is empty")
            return
        }
    
        registerUser(username: DataManager.shared.username, email: username, password: password)
    }
    
    private func loginUser() {
        guard let username = emailTextField.text, !username.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
            showToast(message: "Username or password is empty")
            return
        }
        showLoader()
        logInUser(username: username, password: password)
    }
    
    private func logOutCurrentUser() {
        currentAuthState = .loggedOut
        DataManager.shared.logout()
    }
    
    private func handleUserLoginError(_ error: Error) {
        showErrorToast(error: error.localizedDescription)
    }
     
    private func handleUserRegistrationError(_ error: Error) {
        showErrorToast(error: error.localizedDescription)
    }
    
    private func getAccessToken() async throws -> String {
        let baseUrl = Constants.Network.baseUrl
        
        return try await MockServerProvider.shared.getAccessToken(baseURL: baseUrl, clientId: Constants.App.clientId, clientSecret: Constants.App.clientSecret)
    }
    
    private func pushToSilentTOTPVC() {
        let vc = AppNavigationManager.initiateViewControllerWith(identifier: .SilentTOTPViewController,
                                                                 storyboardName: .Main) as? SilentTOTPViewController
        
        guard let vc else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
