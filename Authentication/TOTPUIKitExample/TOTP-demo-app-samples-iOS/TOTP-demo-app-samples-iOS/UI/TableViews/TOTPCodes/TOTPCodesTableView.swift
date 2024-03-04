//
//  TOTPCodesTableView.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import UIKit
import TSAuthenticationSDK

class TOTPCodesTableView: UITableView {
    
    var timer: Timer?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDefaults()
    }
    
    private func initDefaults() {
        register(TOTPCodeTableViewCell.nib(), forCellReuseIdentifier: TOTPCodeTableViewCell.identifier)
    }
    
    

    
}


