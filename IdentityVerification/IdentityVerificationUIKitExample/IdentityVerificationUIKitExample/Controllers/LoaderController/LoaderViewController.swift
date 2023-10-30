//
//  LoaderViewController.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

class LoaderViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.startAnimating()
    }
}
