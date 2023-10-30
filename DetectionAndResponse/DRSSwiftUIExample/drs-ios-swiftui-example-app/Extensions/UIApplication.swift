//
//  UIApplication.swift
//  drs-ios-swiftui-example-app
//
//  Created by Tomer Picker on 20/06/2023.
//

import UIKit

extension UIApplication {
   func endEditing() {
       sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}
