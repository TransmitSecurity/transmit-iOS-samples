import Foundation
import UIKit

class RejectAccessViewController: BaseViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        removeBackButton()
    }
    
    override func submitButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
