//
//  TOTPCodeCellModel.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import Foundation

class TOTPCodeCellModel {
    
    var issuer: String
    var label: String
    var uuid: String
    var code: String
    var counter: String
    var biometric: Bool
    
    init(issuer: String, label: String, uuid: String, code: String, counter: String, biometric: Bool) {
        self.issuer = issuer
        self.label = label
        self.uuid = uuid
        self.code = code
        self.counter = counter
        self.biometric = biometric
    }
}
