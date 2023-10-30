//
//  Dictionary.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 19/09/2023.
//

import Foundation


extension Dictionary where Key == String, Value == Any {
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        let object = try? JSONDecoder().decode(type, from: data)
        
        return object
    }
}
