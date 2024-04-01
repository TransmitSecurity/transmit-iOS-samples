import UIKit
import IdentityOrchestration

class BaseViewController: UIViewController, NibLoadable, ActionHandlerProtocol {
    
    var data: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var submitButtonTitle: String? {
        data?["button_text"] as? String ?? "OK"
    }
    
    func reloadData() {
        debugPrint("Data of: \(self.debugDescription) was reloaded")
    }

    func showErrorToast(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorToast(message: error)
        }
       
    }
    
    func startLoadingIndicator() {
        TSLoadingIndicator.shared.startAnimation()
    }
    
    func stopLoadingIndicator() {
        TSLoadingIndicator.shared.stopAnimation()
    }
    
    func submitButtonTapped() {
        // Should be implemented in subclasses
        startLoadingIndicator()
    }
    
    func submitClientResponse(data: [String: Any]? = nil, optionId: TSIdoClientResponseOptionType) {
        TSIdo.submitClientResponse(clientResponseOptionId: optionId, data: data)
    }
    
    @IBAction func onSubmitButton(_ sender: UIButton) {
        submitButtonTapped()
    }
    
    func handle(_ response: TSIdoServiceResponse, navigationController: UINavigationController?) {
        guard let actionData = response.data else { debugPrint("[DEBUG] No data found in response object"); return }
        
        self.data = actionData
        
        navigationController?.pushViewController(self, animated: true)
    }
}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}

