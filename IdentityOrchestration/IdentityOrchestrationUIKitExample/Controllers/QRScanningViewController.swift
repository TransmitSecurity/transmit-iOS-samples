//
//  QRScanningViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 26/09/2023.
//

import UIKit
import AVFoundation

class QRScanningViewController: BaseViewController {
    
    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var formSubtitle: UILabel!
    
    private var scannedData: String? = nil

    // Set up the camera and capture session
    let captureSession = AVCaptureSession()
    lazy var videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    private let sessionQueue = DispatchQueue(label: "com.ido.qrScanner.", qos: .background, attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreensManager.shared.delegate = self
        
        // Set up the capture session
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let input = try? AVCaptureDeviceInput(device: captureDevice!)
        captureSession.addInput(input!)
        
        // Set up the metadata output
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // Start the capture session
        view.layer.addSublayer(videoPreviewLayer)

        view.bringSubviewToFront(formTitle)
        view.bringSubviewToFront(formSubtitle)
        
        startSession()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer.frame = view.layer.bounds
    }

}

extension QRScanningViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadata object contains a QR code
        if metadataObjects.count == 0 {
            return
        }
        
        // Get the first metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr,
           let data = metadataObj.stringValue {
            
            dataScanned(data)
            
            stopSession()
        }
    }
}

private extension QRScanningViewController {
    private func startSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    func dataScanned(_ data: String?) {
        guard let data else { return }
        guard scannedData == nil else { return }
        
        scannedData = data
        showLoader()
        ScreensManager.shared.startCrossDeviceJourney(messageId: scannedData ?? "")
    }
    
}

extension QRScanningViewController: ScreensManagerDelegate {
    
    func journeyViewDidChange(controller: UIViewController) {
        pushTo(vc: controller)
    }
    
    func journeyViewDataDidChange(data: [String: Any]) {
        
    }
    
    
}
