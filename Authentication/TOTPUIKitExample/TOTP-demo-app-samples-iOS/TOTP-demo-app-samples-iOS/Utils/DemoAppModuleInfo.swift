//
//  DemoAppModuleInfo.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import Foundation
import TSCoreSDK

struct DemoAppModuleInfo: ITSModuleInfo {

    static let shared = DemoAppModuleInfo()
    
    private init() { }
    
    func subSystemName() -> String { "tsx-totp-demo-app" }
    
    func isLoggerEnabled() -> Bool { false }
    
    func endpointIgnoreList() -> Array<String>? { nil }
    
    func tenantID() -> String { "N/A" }
    
    func version() -> String { Bundle.main.version }
}
