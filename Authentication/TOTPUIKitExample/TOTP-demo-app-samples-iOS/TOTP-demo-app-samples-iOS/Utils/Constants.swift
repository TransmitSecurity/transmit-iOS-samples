//
//  Constants.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import Foundation

struct Constants {

    struct App {
        static let clientId = "rzthg833t7rza1enxh5mefw1w5mi6yts"
    }
    
}

extension Constants {
    struct Network { }
}

extension Constants.Network {
    struct ParamsKeys {
        static let clientId = "client_id"
        static let clientSecret =
        static let grantType = "grant_type"
        static let username = "username"
        static let password = "password"
        static let usernameType = "username_type"
    }
    
    struct HeadersKeys {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    struct GrantType {
        static let credantials = "client_credentials"
    }
}
