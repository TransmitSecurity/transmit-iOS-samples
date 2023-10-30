//
//  ViewController.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation
import UIKit
import Combine
import AVFoundation
import IdentityVerification

class ViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var consetText: UITextView!
    @IBOutlet weak var startButton: CustomButtonView!
    @IBOutlet weak var checkboxView: CheckboxView!
    fileprivate(set) var isChecked = false
    private var anyCancellable: AnyCancellable? = nil
    
    private var baseUrl: String = ""
    private var clientId: String = ""
    private var clientSecret: String = ""
    private var startToken: String?
    private var sessionID: String?
    fileprivate var loaderVC : LoaderViewController?

    private let prepareVerificationData = [GenericTableViewCellModel(title: "You use a Driver license, National ID or passport only", icon:                                                        "ic_document"),
                                           GenericTableViewCellModel(title: "Document is not expired or damaged", icon:                                                        "ic_expired"),
                                           GenericTableViewCellModel(title: "Your capture is easily readible, layed on a solid background", icon:                                                        "ic_readible"),
                                           GenericTableViewCellModel(title: "No photo copies or screen capture", icon:                                                        "ic_capture")]
    /**
     Setting this property to true will simulate recapature process.
     However, it's important to note that the recapature simulation will only occur once.
     verificationRequiresRecapture() function will be triggered, to notify the recatprue reason.
     */
    private var simulateRecapture: Bool = false
    
    var state: VerificationProcessState? = nil {
        didSet {
            DispatchQueue.main.async {
                self.pushToVerificationProcessVC()
            }
        }
    }
    
    struct Texts {
        static let mainTitle = "Prepare For Verification"
        static let subTitle = "This should take a few moments. In order to assure the verification succeeds, please make sure that"
        static let btnTitle = "Start"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.baseUrl = Constants.Network.baseUrl
        self.clientId = Constants.App.clientId
        self.clientSecret = Constants.App.clientSecret
    }
    
    private func setupUI() {
        mainTitle.text = Texts.mainTitle
        subTitle.text = Texts.subTitle
        initDefaults()
        setHyperLinkedText()
        startButton.initView(isEnable: false, buttonText: Texts.btnTitle, listener: self)
        checkboxView.initView(listener: self)
    }
    
    private func initDefaults() {
        tableView.register(GenericTableViewCell.nib(), forCellReuseIdentifier: GenericTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    private func setHyperLinkedText() {
        consetText.addHyperLinksToText(originalText: "I agree to the Terms & Conditions and the Privacy Policy", hyperLinks: ["Terms & Conditions": Constants.Links.termsOfService, "Privacy Policy": Constants.Links.privacyStatement])
        consetText.isEditable = false
        consetText.contentSize.height = 42
    }
    
    private func toggleStartButton(clicked: Bool) {
        self.startButton.toggleButton(isEnable: clicked)
    }
    
    private func observeVerificationProcessState() {
        anyCancellable = VerificationProcessStatus.shared.status.sink { status in
            guard status != .initialize else { return }
            self.handleStateUpdates(status: status)
        }
    }
    
    private func handleStateUpdates(status: VerificationProcessState) {
        state = status
    }
    
    private func pushToVerificationProcessVC() {
        anyCancellable = nil
        let vc = AppNavigationManager.initiateViewControllerWith(identifier: .VerificationProcessViewController, storyboardName: .Main) as! VerificationProcessViewController
        vc.sessionID = sessionID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func startSession() {
        showLoader()
        startVerificationProcess()
    }
    
    private func requestCameraPermission(startToken: String) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.startSDK(startToken: startToken)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                self.startSDK(startToken: startToken)
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
        DispatchQueue.main.async {
            self.hideLoader()
        }
        observeVerificationProcessState()
        TSIdentityVerification.start(startToken: startToken)
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

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prepareVerificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.identifier, for: indexPath) as! GenericTableViewCell
        cell.initCell(cell: prepareVerificationData[indexPath.row])
        return cell
    }
    
}


extension ViewController: CustomButtonViewDelegate {
    func clicked() {
        self.startSession()
    }
}

extension ViewController: CheckboxViewDelegate {
    func clicked(clicked: Bool) {
        toggleStartButton(clicked: clicked)
    }
}

extension ViewController {
    func showLoader() {
        loaderVC = AppNavigationManager.initiateViewControllerWith(identifier: .LoaderViewController, storyboardName: .Main) as? LoaderViewController
        guard let vc = loaderVC else {return}
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    
    func hideLoader(){
        self.loaderVC?.removeFromParent()
        self.loaderVC?.view.removeFromSuperview()
    }
}
