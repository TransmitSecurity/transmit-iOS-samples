//
//  Nameable.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import Foundation
import UIKit

protocol Nameable: NSObject {
    static var defaultName: String { get }
}

extension Nameable {
    static var defaultName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
