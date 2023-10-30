//
//  JourneyConfiguration.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 18/09/2023.
//


import Foundation
import IdentityOrchestration

// MARK: - Current Working Journey

struct IdoJourney {
    static let currentJourneyConfiguration: JourneyConfiguration = IdoJourneyConfiguration.mobileSdk
}

enum JourneyId: String {
    case mobileSdk = "ciam_orch_mobile_sdk"
    
    case waitForDevice = "wait_for_device"
    
    case crossDevice = "cross_device"
}

protocol JourneyConfiguration {
    var journeyId: JourneyId { get }
    
    var options: IdoStartJourneyOptions? { get }
}

struct IdoJourneyConfiguration: JourneyConfiguration {
    let journeyId: JourneyId
    
    let options: IdoStartJourneyOptions?
}


extension IdoJourneyConfiguration {
    
    static func crossDevice(messageId: String) -> IdoJourneyConfiguration {
        .init(journeyId: .crossDevice, options: .init(additionalParams: ["messageId": messageId]))
    }
    
    static var waitForDevice: IdoJourneyConfiguration {
        .init(journeyId: .waitForDevice, options: .init(additionalParams: ["username": "John Doe", "plus": "false"]))
    }
    
    static var mobileSdk: IdoJourneyConfiguration {
        .init(journeyId: .mobileSdk, options: .init(additionalParams: ["username": "John Doe", "plus": "false"]))
    }
    
    private static let defaultOptions: IdoStartJourneyOptions = .init(additionalParams: ["username": "John Doe",
                                                                                         "plus": "false"], flowId: nil)

    
    init(journeyId: JourneyId, options: IdoStartJourneyOptions = Self.defaultOptions) {
        self.journeyId = journeyId
        self.options = options
    }
}
