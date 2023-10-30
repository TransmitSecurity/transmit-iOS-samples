//
//  WaitForTicketViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 20/09/2023.
//

import UIKit
import IdentityOrchestration


struct WaitForTicketViewInputData: Decodable {
    let ticket: Ticket?
    let rawTicketId: String?
    let text: String?
    let pollingTimeout: Int?
    let mainTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case ticket = "ticket_id"
        case rawTicketId = "raw_ticket_id"
        case text
        case mainTitle = "title"
        case pollingTimeout = "polling_timeout"
    }
}

struct Ticket: Decodable {
    
    let value: String?
    
    let format: Format?
    
    let alt: String?
}

enum Format: String, Decodable {
    case qrCode = "qrcode"
}

class WaitForTicketViewController: BaseViewController {

    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var ticketId: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    
    var data: WaitForTicketViewInputData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreensManager.shared.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        formTitle.text = data?.mainTitle ?? "Wait For Device"
        ticketId.text = data?.rawTicketId ?? ""
        setQRImage()
        qrImage.isHidden = true
    }
    
    private func setQRImage() {
        if let image = getQRCodeImage() {
            qrImage.image = image
        }
    }
    
    private func getQRCodeImage() -> UIImage? {
        guard let ticketId = data?.rawTicketId else {
            debugPrint("Missing raw ticket id")
            return nil
        }
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = ticketId.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        
        return UIImage(data: uiimage.pngData()!)
    }
    
    private func handleViewDataDidChange(actionData: [String: Any]) {
        self.data = actionData.decode(WaitForTicketViewInputData.self)!
        setupUI()
    }
    
    @IBAction func startPollingButtonClicked(_ sender: Any) {
        qrImage.isHidden = false
        TSIdentityOrchestration.submitClientResponse(clientResponseOptionId: .clientInput, data: [:])
    }
    
}

extension WaitForTicketViewController: ScreensManagerDelegate {
    func journeyViewDidChange(controller: UIViewController) {
        pushTo(vc: controller)
    }
    
    func journeyViewDataDidChange(data: [String: Any]) {
        qrImage.isHidden = true
        handleViewDataDidChange(actionData: data)
    }
    
}
