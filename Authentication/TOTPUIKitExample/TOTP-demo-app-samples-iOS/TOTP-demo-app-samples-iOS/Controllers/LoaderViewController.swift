//
//  LoaderViewController.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 09/03/2024.
//

import UIKit

class LoaderViewController: UIViewController {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loader.startAnimating()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
