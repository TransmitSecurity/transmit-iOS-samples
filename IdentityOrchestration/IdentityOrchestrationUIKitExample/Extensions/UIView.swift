//
//  UIView.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 19/09/2023.
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

