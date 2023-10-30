//
//  RecommendationViewModel.swift
//  webAuthn-demo-app-samples-iOS
//
//  Created by Tomer Picker on 11/09/2023.
//

import Foundation
import Combine

class RecommendationViewModel: ObservableObject {
    
    @Published var state: ProcessState = .initialize
    private var anyCancellable: AnyCancellable? = nil
    private var resultObservation: AnyCancellable? = nil
    

    init() {
        observeProcessState()
    }
    
    private func observeProcessState() {
        anyCancellable = ProcessStatus.shared.status.sink { [weak self] status in
            DispatchQueue.main.async {
                self?.state = status
            }
        }
    }
    

}
