//
//  DemoAppModuleInfo.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 10/09/2023.
//

import Foundation
import TSCoreSDK

struct DemoAppModuleInfo: ITSModuleInfo {

    static let shared = DemoAppModuleInfo()
    
    private init() { }
    
    func subSystemName() -> String { "tsx-pass-keys-demo-app" }
    
    func isLoggerEnabled() -> Bool { false }
    
    func endpointIgnoreList() -> Array<String>? { nil }
    
    func tenantID() -> String { "N/A" }
    
    func version() -> String { Bundle.main.version }
}
