//
//  MainViewModel.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import AVFoundation
import IdentityVerification
import SwiftUI
import Combine


class MainViewModel: ObservableObject {
    @Published var prepareVerificationData = [GenericListViewData(title: "You use a Driver license, National ID or passport only", icon:                                                        "ic_document"),
                                              GenericListViewData(title: "Document is not expired or damaged", icon:                                                        "ic_expired"),
                                              GenericListViewData(title: "Your capture is easily readible, layed on a solid background", icon:                                                        "ic_readable"),
                                              GenericListViewData(title: "No photo copies or screen capture", icon:                                                        "ic_capture")]
    @Published var moveToVerificationProcessView = false
    @Published var isLoading = false
    
    private var baseUrl: String = ""
    private var clientId: String = ""
    private var clientSecret: String = ""
    private var anyCancellable: AnyCancellable? = nil
    private var startToken: String?
    private var sessionID: String?
    /**
     Setting this property to true will simulate recapature process.
     However, it's important to note that the recapature simulation will only occur once.
     verificationRequiresRecapture() function will be triggered, to notify the recatprue reason.
     */
    private var simulateRecapture: Bool = false

    
    var state: VerificationProcessState? = nil {
        didSet {
            DispatchQueue.main.async {
                self.moveToVerificationProcessView = true
            }
        }
    }
    
    init() {
        self.baseUrl = Constants.Network.baseUrl
        self.clientId = Constants.App.clientId
        self.clientSecret = Constants.App.clientSecret
    }
    
    private func observeVerificationProcessState() {
        anyCancellable = VerificationProcessStatus.shared.status.sink { status in
            guard status != .initialize else { return }
            self.handleStateUpdates(status: status)
        }
    }
    
    private func handleStateUpdates(status: VerificationProcessState) {
        state = status
        guard state == .completed else { return }
        getVerificationResult()
    }
            
    private func requestCameraPermission(startToken: String) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.startSDK(startToken: startToken)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    self.startSDK(startToken: startToken)
                }
            }
            break
        case .denied:
            self.startSDK(startToken: startToken)
            break
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func startSDK(startToken: String) {
        TSIdentityVerification.start(startToken: startToken)
        observeVerificationProcessState()
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    private func startVerificationProcess() {
        Task {
            
            var mockBehavior: CreateSessionRequest.MockBehavior?
            if simulateRecapture {
                mockBehavior = .init(processingTime: "5s",
                                     recommendation: "ALLOW",
                                     forceRetry: true)
            }
            
            let sessionData = try await MockServerProvider.shared.createSession(clientId: clientId, clientSecret: clientSecret, mockBehavior: mockBehavior)
            
            guard let startToken = sessionData.startToken, let sessionID = sessionData.sessionId else { return }
            self.startToken = startToken
            self.sessionID = sessionID
            
            requestCameraPermission(startToken: startToken)
        }
    }
    
    func startSession() {
        isLoading = true
        startVerificationProcess()
    }
    
        
    func getVerificationResult() {
        Task {
            guard let sessionID = self.sessionID else { return }
            let verficationResult = try await MockServerProvider.shared.getVerfication(clientId: self.clientId, clientSecret: self.clientSecret, sessionID: sessionID)
            debugPrint("verfication result:", verficationResult.recommendation, verficationResult.status)
        }
    }
}


