//
//  UIView.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation
import UIKit

extension UIView {
    
    func setCornerRadius(_ cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = cornerRadius - 1
        self.layer.masksToBounds = true
    }
    
}
