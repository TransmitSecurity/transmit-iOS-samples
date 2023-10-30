//
//  Constants.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import Foundation
import SwiftUI

struct Constants {
    
    struct App {
        static let domain = "shopcart.userid-stg.io"
        static let clientId = "5nhc16n9f165t4gp0todzd37qzfr9oxq"
        static let clientSecret =
    }
    
    struct Network {
        static let baseUrl = "https://api.transmitsecurity.io/cis"
    }
    
    struct Icons {
        static let logo = Image("ic_gcash")
        static let MainIcon = Image("ic_user")
    }
    
    struct Fonts {
        struct Inter {
            static let regular = "Inter-Regular"
            static let semiBold = "Inter-SemiBold"
        }
    }
    
    struct Colors {
        static let primaryGrey = Color("colors_primary_grey")
        static let primaryBlue = Color("colors_primary_blue")
    }
    
}

extension Constants.Network {
    struct ParamsKeys {
        static let clientId = "client_id"
        static let clientSecret =
        static let grantType = "grant_type"
        static let actionToken = "action_token"
        static let userId = "user_id"
    }
    
    struct HeadersKeys {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    struct GrantType {
        static let credantials = "client_credentials"
    }
}
