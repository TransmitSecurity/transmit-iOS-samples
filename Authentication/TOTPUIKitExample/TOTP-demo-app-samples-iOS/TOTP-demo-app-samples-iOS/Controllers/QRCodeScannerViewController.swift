//
//  QRCodeScannerViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import Foundation
import UIKit
import AVFoundation

protocol QRCodeScannerDelegate: AnyObject {
    func didRecieveTOTPInfo(_ totpInfo: DataManager.TOTPInfo?)
}

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    weak var delegate: QRCodeScannerDelegate?
    var dataScanned: String = ""
    var sessionDidStop = false
    let captureSession = AVCaptureSession()
    
    lazy var videoPreviewLayer =  {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.videoGravity = .resizeAspectFill
        
        return videoLayer
    } ()
    
    
    private let sessionQueue = DispatchQueue(label: "com.TSauthenticationSDK.qrScanner.", qos: .background, attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

        startSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer.frame = .init(x: 0, y: 100, width: view.layer.bounds.width, height: view.layer.bounds.height - 100)
    }
    

    @IBAction func onCloseBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadata object contains a QR code
        if metadataObjects.count == 0 {
            return
        }
        
        // Get the first metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr,
           let data = metadataObj.stringValue {
            
            self.dataScanned = data
            
            stopSession()
            
        }
    }
    
}

private extension QRCodeScannerViewController {
    private func startSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    
    private func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.captureSession.stopRunning()
            
            if !self.sessionDidStop {
                sessionDidStop = true
                DispatchQueue.main.async {
                    self.pushToRegisterTOTPViewController()
                }
            }
         
        }
    }
    
    
    private func pushToRegisterTOTPViewController() {
                
        let vc = AppNavigationManager.initiateViewControllerWith(identifier: .RegisterTOTPViewController,
                                                                 storyboardName: .Main) as? RegisterTOTPViewController
        vc?.delegate = self
        vc?.URI = self.dataScanned
        
        guard let vc else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QRCodeScannerViewController: RegisterTOTPDelegate {
    
    func didRecieveTOTPInfo(_ totpInfo: DataManager.TOTPInfo?) {
        self.delegate?.didRecieveTOTPInfo(totpInfo)
    }
    
}
