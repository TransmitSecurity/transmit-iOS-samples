//
//  ViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 18/09/2023.
//

import UIKit
import IdentityOrchestration

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initJourney()
        ScreensManager.shared.delegate = self
    }


    private func initJourney() {
        TSIdentityOrchestration.initialize(clientId: Constants.Credentials.clientId,
                                           options: .init(serverPath: Constants.Network.baseUrl,
                                                          applicationId: Constants.Credentials.applicationId))
        
        TSIdentityOrchestration.delegate = ScreensManager.shared
    }
    
    private func startJourney() {
        showLoader()
        let configuration = IdoJourney.currentJourneyConfiguration
        ScreensManager.shared.startCurrentJourney(configuration: configuration)
    }
    
    @IBAction func startJourneyButtonClicked(_ sender: Any) {
        startJourney()
    }
    
    @IBAction func processTicketButtonClicked(_ sender: Any) {
        let vc = NavigationManager.initiateViewControllerWith(identifier: .QRScanningViewController, storyboardName: .Main) as! QRScanningViewController
        pushTo(vc: vc)
    }
}

extension MainViewController: ScreensManagerDelegate {
    
    func journeyViewDidChange(controller: UIViewController) {
        hideLoader()
        pushTo(vc: controller)
    }
    
}
