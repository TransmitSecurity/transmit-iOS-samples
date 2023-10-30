//
//  ViewController.swift
//  drs-ios-example-app
//
//  Created by Tomer Picker on 24/04/2023.
//

import UIKit
import AccountProtection

class MainViewController: UIViewController {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var actionTextField: UITextField!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    private let actionTypes = ["login", "register", "transaction", "password_reset", "logout", "checkout", "account_details_change", "account_auth_change", "withdraw", "credits_change"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDefaults()
        setupUI()
    }
    
    private func initDefaults() {
        actionsTableView.register(ActionTableViewCell.nib(), forCellReuseIdentifier: ActionTableViewCell.identifier)
        actionsTableView.delegate = self
        actionsTableView.dataSource = self
        actionsTableView.backgroundColor = UIColor.white
    }
    
    private func setupUI(){
        self.actionsTableView.layer.masksToBounds = false
        self.actionsTableView.isHidden = true
        let borderColor = UIColor.gray
        self.userIdTextField.layer.borderColor = borderColor.cgColor
        self.actionTextField.layer.borderColor = borderColor.cgColor
        self.userIdTextField.layer.cornerRadius = 15.0
        self.actionTextField.layer.cornerRadius = 15.0
        self.userIdTextField.layer.borderWidth = 1.0
        self.actionTextField.layer.borderWidth = 1.0
    }
    
    private func createActionSheet(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel) { _ in})

        return alert
    }
    
    private func showAlert(title: String, message: String) {
        let actionSheet = createActionSheet(title: title, message: message)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func toggleTableView() {
        UIView.animate(withDuration: 0.1) {
            self.actionsTableView.isHidden = !self.actionsTableView.isHidden
            self.arrowIcon.transform = self.arrowIcon.transform.rotated(by: .pi)
        }
    }
    
    @IBAction func setUserIdButtonClicked(_ sender: Any) {
        guard let userId = userIdTextField.text, !userId.isEmpty else {
            self.showAlert(title: "Error", message: "User id field is empty")
            return
        }
        
        TSAccountProtection.setUserId(userId)
    }
    
    @IBAction func selectActionButtonClicked(_ sender: Any) {
        toggleTableView()
    }
    
    @IBAction func reportActionButtonClicked(_ sender: Any) {
        guard let action = actionTextField.text, !action.isEmpty else {
            self.showAlert(title: "Error", message: "Please select action type")
            return
        }

        TSAccountProtection.triggerAction(action) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    debugPrint("token: \(response.actionToken)")
                    self.showAlert(title: "Action: \(action) was successfully sent to server", message: "token: \(response.actionToken)")
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    let errorMessage: String
                    switch error {
                    case .disabled:
                        errorMessage = "Action is Disabled"
                    case .connectionError:
                        errorMessage = "Connection Error"
                    case .internalError:
                        errorMessage = "Internal Error"
                    case .notSupportedActionError:
                        errorMessage = "Action: \(action) IS NOT SUPPORTED"
                    @unknown default:
                        errorMessage = "Unknown Error"
                    }
                    self.showAlert(title: "Error was encountered", message: errorMessage)
                }
            }
        }
    }
    
    @IBAction func clearUserButtonClicked(_ sender: Any) {
        TSAccountProtection.clearUser()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionTableViewCell.identifier, for: indexPath) as! ActionTableViewCell
        cell.initCell(action: actionTypes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.actionTextField.text = actionTypes[indexPath.row]
        toggleTableView()
    }
    
}

