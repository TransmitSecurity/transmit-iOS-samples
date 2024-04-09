
import UIKit
import IdentityOrchestration

class ViewController: BaseViewController {

    let actionHandlersMap: [String: ActionHandlerProtocol.Type] = [
        "Error": ErrorViewController.self,
        "Rejection": RejectAccessViewController.self,
        "email": FormEmailViewController.self,
        "phone": FormPhoneViewController.self,
        "Information": DisplayInformationViewController.self,
        "Success": CompleteJourneyViewController.self,
        "DrsTriggerAction": DRSViewController.self,
        "NativeBiometricsRegistration": NativeBiometricsRegistrationViewController.self
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeIDOSDK()
    }

    @IBAction func onStartJourney(_ sender: Any) {
        startJourney()
    }
    
    // MARK: - IDO Initialization
    private func initializeIDOSDK() {
        do {
            try TSIdo.initializeSDK()
        } catch {
            debugPrint("[DEBUG] SDK Initialization error: \(error)")
        }
        
        TSIdo.delegate = self
    }
    
    private func startJourney() {
        startLoadingIndicator()
        TSIdo.startJourney(journeyId: Settings.journeyId)
    }
    
    private var presentedController: BaseViewController? {
        presentedViewController as? BaseViewController
    }
}

 
extension ViewController: TSIdoDelegate {
    func TSIdoDidReceiveResult(_ result: Result<TSIdoServiceResponse, TSIdoJourneyError>) {
        stopLoadingIndicator()
        
        switch result {
        case .success(let response):
            self.handleIdoResponse(response)
        case .failure(let error):
            self.handleJourneyError(error)
        }
    }
    
    private func handleIdoResponse(_ response: TSIdoServiceResponse) {
        guard let stepId = response.journeyStepId else {
            debugPrint("[DEBUG] Missing step id in the journey response")
            return
        }
        
        let handler = actionHandlersMap[stepId.identifier]?.instantiate()
        
        handler?.handle(response, navigationController: navigationController)
    }
    
    private func handleJourneyError(_ error: TSIdoJourneyError) {
        debugPrint("[DEBUG] Journey error occured: \(error.localizedDescription)")
        
        showAlert(title: error.title, message: error.message)
    }
}
