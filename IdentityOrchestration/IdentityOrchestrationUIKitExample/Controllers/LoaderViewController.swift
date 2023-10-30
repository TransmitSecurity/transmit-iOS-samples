//
//  LoaderViewController.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 20/09/2023.
//

import UIKit

class LoaderViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loader.startAnimating()
    }
    
}
