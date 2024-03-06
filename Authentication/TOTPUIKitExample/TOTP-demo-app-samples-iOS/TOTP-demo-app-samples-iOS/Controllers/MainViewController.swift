//
//  ViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import UIKit
import TSAuthenticationSDK

class MainViewController: UIViewController {
    
    @IBOutlet weak var addCodeBtn: UIButton!
    @IBOutlet weak var codesTableView: TOTPCodesTableView!
    let cellHeight : CGFloat = 100
    
    var timer: Timer?
    var counter: String = ""

    private var totpModels: [TOTPCodeCellModel] = [TOTPCodeCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        addCodeBtn.setTitle("", for: .normal)
        setTOTPInfoTable()
    }
    
    private func setTOTPInfoTable() {
        codesTableView.delegate = self
        codesTableView.dataSource = self
        fetchAndMapSavedTOTPToCellModel()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onInterval), userInfo: nil, repeats: true)
        timer?.fire()
        codesTableView.reloadData()
    }
    
    
    @objc func onInterval() {
        
        updateTOTPCodes()
        updateCounter()
    }
    
    private func updateCounter() {
        let period = 30
        let secondsPast1970 = Int(floor(Date().timeIntervalSince1970))
        
        let counterValue = period - secondsPast1970 % period
                
        self.counter = counterValue.description
    }
    
    
    private func generateAndUpdateCellCode(_ cell: TOTPCodeTableViewCell, for uuid: String) {
        TSAuthentication.shared.generateTOTPCode(UUID: uuid) { [weak self] result in
            switch result {
            case .success(let response):
                if cell.uuid == uuid {
                    cell.code.text = response.code
                    cell.counter.text = self?.counter
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                cell.code.text = "error"
            }
        }
    }
    
    
    private func updateTOTPCodes() {
        for visibleCell in self.codesTableView.visibleCells  {
            if let cell = visibleCell as? TOTPCodeTableViewCell {
                
                let uuid = cell.uuid
                
                if !cell.biometric {
                    generateAndUpdateCellCode(cell, for: uuid)
                }
        
            }
        }
    }
    
    private func fetchAndMapSavedTOTPToCellModel() {
        let savedItems = DataManager.shared.fetchItems()
        
        self.totpModels = savedItems.map({ (element) -> TOTPCodeCellModel in
            TOTPCodeCellModel(issuer: element.issuer, label: element.label, uuid: element.uuid, code: "", counter: "", biometric: element.biometric)
        })
        
    }
        
    
//    private func presentToScanQRCodeScreen() {
//        let vc = AppNavigationManager.initiateViewControllerWith(identifier: .QRCodeScannerViewController,
//                                                                 storyboardName: .Main) as? QRCodeScannerViewController
//        
//        vc?.delegate = self
//        
//        guard let vc else { return }
//        
//        let navigationController = UINavigationController(rootViewController: vc)
//
//        self.present(navigationController, animated: true, completion: nil)
//    }
    
    private func pushToRegisterTOTPViewController() {
                
        let vc = AppNavigationManager.initiateViewControllerWith(identifier: .RegisterTOTPViewController,
                                                                 storyboardName: .Main) as? RegisterTOTPViewController
        
        guard let vc else { return }
        
        vc.delegate = self
        vc.URI = "otpauth://totp/ACME%20Co:jdoe@example.com?secret=AUSJD7LZ5H27TAC7NW2IJMATDMVDUPUG&issuer=ACME%20Co&algorithm=SHA1&digits=6&period=30"
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    @IBAction func addCodeBtnClicked(_ sender: Any) {
//        presentToScanQRCodeScreen()
        pushToRegisterTOTPViewController()
    }
        
}

extension MainViewController: RegisterTOTPDelegate {
    
    func didRecieveTOTPInfo(_ totpInfo: DataManager.TOTPInfo?) {
        guard let totpInfo else { return }
        
        totpModels.append(TOTPCodeCellModel(issuer: totpInfo.issuer, label: totpInfo.label, uuid: totpInfo.uuid, code: "", counter: "", biometric: totpInfo.biometric))
        codesTableView.reloadData()
        
        DataManager.shared.addItem(totpInfo)
    }
    
}



extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totpModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TOTPCodeTableViewCell.identifier, for: indexPath) as! TOTPCodeTableViewCell
        // in case cell already has code
        totpModels[indexPath.row].code = cell.code.text ?? ""
        cell.setModel(totpModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TOTPCodeTableViewCell else { return }

        let uuid = cell.uuid
        
        if !cell.biometric {
            cell.didGenerateClicked = nil
            generateAndUpdateCellCode(cell, for: uuid)
        } else {
            cell.didGenerateClicked = { [weak self] uuid in
                self?.generateAndUpdateCellCode(cell, for: uuid)
            }
        }

    }
    
}
