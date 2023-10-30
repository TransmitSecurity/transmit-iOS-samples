//
//  VerificationProcessViewModel.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import SwiftUI
import Combine
import IdentityVerification

class VerificationProcessViewModel: ObservableObject {
    
    @Published var state: VerificationProcessState
    private var anyCancellable: AnyCancellable? = nil

    init() {
        self.state = VerificationProcessStatus.shared.status.value
        observeVerificationProcessState()
    }
    
    private func observeVerificationProcessState() {
        anyCancellable = VerificationProcessStatus.shared.status.sink { [self] status in
            self.state = status
        }
    }
    
    func recapture() {
        TSIdentityVerification.recapture()
    }

}
