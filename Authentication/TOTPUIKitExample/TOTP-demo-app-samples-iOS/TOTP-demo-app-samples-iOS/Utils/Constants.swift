//
//  Constants.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import Foundation

struct Constants {

    struct App {
        static let clientId = "xmTmsFeSY9Q8KrmK9B_Pn"
        static let clientSecret =
    }
}

extension Constants {
    struct Network { }
}

extension Constants.Network {
    
    static let baseUrl = "https://api.transmitsecurity.io"

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
