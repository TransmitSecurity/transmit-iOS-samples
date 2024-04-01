import Foundation
import UIKit

class CompleteJourneyViewController: BaseViewController {
        
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        removeBackButton()
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
    
    override func submitButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
