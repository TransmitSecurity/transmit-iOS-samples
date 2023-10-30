//
//  Constants.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import UIKit

struct Constants {
    struct Network {
        static let baseUrl = "https://api.transmitsecurity.io"
    }
    
    struct App {
        static let clientId = "ENTER_YOUR_CLIENT_ID"
        static let clientSecret = "ENTER_YOUR_CLIENT_SECRET"
    }
    
    struct GrantType {
        static let credantials = "client_credentials"
    }
    
    struct ParamsKeys {
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
        static let grantType = "grant_type"
    }
    
    struct HeadersKeys {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    struct Fonts {
        struct Inter {
            static let regular = "Inter-Regular"
            static let semiBold = "Inter-SemiBold"
        }
    }
    
    struct Icons {
        static let logo = UIImage(named: "transmit-main-logo")
    }
    
    struct Colors {
        static let primaryBlue = UIColor(named: "colors_primary_blue")
        static let primaryGrey = UIColor(named: "colors_primary_grey")
    }
    
    struct Links {
        static let termsOfService = "https://www.transmitsecurity.com/legal/transmit-security-terms-of-service"
        static let privacyStatement = "https://www.transmitsecurity.com/legal/transmit-security-privacy-statement"
    }
}

