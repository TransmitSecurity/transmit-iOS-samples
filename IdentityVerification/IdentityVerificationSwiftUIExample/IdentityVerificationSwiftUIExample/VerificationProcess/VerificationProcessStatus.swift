//
//  VerificationProcessStatus.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI
import Combine
import IdentityVerification

final class VerificationProcessStatus: ObservableObject {
    var status: CurrentValueSubject<VerificationProcessState,Never> = .init(.initialize)
    
    static let shared = VerificationProcessStatus()
    private init() {}
}
