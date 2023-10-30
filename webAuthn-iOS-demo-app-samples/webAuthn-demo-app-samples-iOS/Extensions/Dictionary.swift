//
//  Dictionary.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func toQueryParamsString() -> String {
        var result = ""
        for (key, value) in self {
            result += "\(key)=\(value)&"
        }
        
        result = String(result.dropLast())
        
        return result
    }
}
