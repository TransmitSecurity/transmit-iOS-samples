//
//  TOTPCodeTableViewCell.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import UIKit


class TOTPCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var issuser: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var generateBtn: UIButton!
    @IBOutlet weak var biometricLabel: UILabel!
    
    var uuid: String = ""
    var biometric: Bool = false
    var didGenerateClicked: ((String) -> Void)?
    
    static let identifier = "TOTPCodeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TOTPCodeTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setModel(_ model: TOTPCodeCellModel){
        self.selectionStyle = .none
        self.counter.text = model.counter
        self.label.text = model.label
        self.issuser.text = model.issuer
        self.code.text = model.code
        self.uuid = model.uuid
        self.biometric = model.biometric
        self.generateBtn.isHidden = !model.biometric
        self.counter.isHidden = model.biometric
        self.biometricLabel.isHidden = !model.biometric
    }
    
    
    @IBAction func gnerateBtnClicked(_ sender: Any) {
        didGenerateClicked?(self.uuid)
    }
    
}
