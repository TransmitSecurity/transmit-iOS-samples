//
//  Dictionary.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    func toQueryParamsString() -> String {
        var result = ""
        for (key, value) in self {
            result += "\(key)=\(value)&"
        }
        
        result = String(result.dropLast())

        // We should percent encode '+' character because + is valid character for url query string, it's url encoded version of [space]
        // And for some reason it encoded as space character on the server
        result = result.addingPercentEncoding(withAllowedCharacters: .urlAllowedCharacters)!
         
        return result
    }
}

extension CharacterSet {
    
    /// Characters valid in part of a URL.
    ///
    /// This set is useful for checking for Unicode characters that need to be percent encoded before performing a validity check on individual URL components.
    static var urlAllowedCharacters: CharacterSet {
        // You can extend any character set you want
        var characters = CharacterSet.urlQueryAllowed
        characters.subtract(CharacterSet(charactersIn: "+"))
        return characters
    }
}
