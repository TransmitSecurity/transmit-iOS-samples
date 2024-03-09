//
//  HomePageViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import UIKit

class HomePageViewController: UIViewController {
    
    
    @IBOutlet weak var scanQRBtn: UIButton!
    @IBOutlet weak var silentRegistrationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanQRBtn.setCornerRadius(12.0)
        silentRegistrationBtn.setCornerRadius(12.0)
    }
    

    @IBAction func scanQRRegistrationBtnClicked(_ sender: Any) {
        let vc = AppNavigationManager.initiateViewControllerWith(identifier: .MainViewController,
                                                                 storyboardName: .Main) as? QRTOTPViewController
                
        guard let vc else { return }

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true

        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func silentRegistrationBtnClicked(_ sender: Any) {
        let vc = AppNavigationManager.initiateViewControllerWith(identifier: .LoginViewController,
                                                                 storyboardName: .Main) as? LoginViewController
                
        guard let vc else { return }

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true, completion: nil)
    }
    

}
