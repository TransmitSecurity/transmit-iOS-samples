//
//  DemoAppModuleInfo.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import Foundation
import TSCoreSDK

struct DemoAppModuleInfo: ITSModuleInfo {

    static let shared = DemoAppModuleInfo()
    
    private init() { }
    
    func subSystemName() -> String { "idv-ios-sample-app" }
    
    func isLoggerEnabled() -> Bool { true }
    
    func endpointIgnoreList() -> Array<String>? { nil }
    
    func tenantID() -> String { "N/A" }
    
    func version() -> String { Bundle.main.version }
}
