//
//  GenericTableViewCell.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import UIKit

class GenericTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    static let identifier = "GenericTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "GenericTableViewCell", bundle: nil)
    }

    func initCell(cell : GenericTableViewCellModel) {
        self.icon.image = UIImage(named: cell.icon)
        self.label.text = cell.title
    }
    
}


