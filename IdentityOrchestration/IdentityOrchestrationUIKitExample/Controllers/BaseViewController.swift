//
//  BaseViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 20/09/2023.
//

import UIKit

class BaseViewController: UIViewController {

    fileprivate var loaderVC : LoaderViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func showLoader() {
        loaderVC = NavigationManager.initiateViewControllerWith(identifier: .LoaderViewController, storyboardName: .Main) as? LoaderViewController
        guard let vc = loaderVC else {return}
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    
    func hideLoader(){
        self.loaderVC?.removeFromParent()
        self.loaderVC?.view.removeFromSuperview()
    }
    
    func pushTo(vc: UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
