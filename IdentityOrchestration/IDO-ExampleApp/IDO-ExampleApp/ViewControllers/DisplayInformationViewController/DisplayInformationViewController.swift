import Foundation
import UIKit

class DisplayInformationViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = data?["title"] as? String
        textLabel.text = data?["text"] as? String
        
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
    
    override func submitButtonTapped() {
        super.submitButtonTapped()
        
        submitClientResponse(optionId: .clientInput)
    }
}
