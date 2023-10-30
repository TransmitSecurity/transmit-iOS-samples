//
//  ActionTableViewCell.swift
//  drs-ios-example-app
//
//  Created by Tomer Picker on 25/04/2023.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actionLabel: UILabel!
    
    static let identifier = "ActionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ActionTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func initCell(action: String) {
        self.actionLabel.text = action
    }
    
}
