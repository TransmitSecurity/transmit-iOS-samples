//
//  BaseViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 06/03/2024.
//

import UIKit


class TSXBaseViewController: UIViewController {
    
    private var loaderVC : LoaderViewController?
    private let loadingIndicator = TSLoadingIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
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
    
    func showErrorToast(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorToast(message: error)
        }
       
    }

}
