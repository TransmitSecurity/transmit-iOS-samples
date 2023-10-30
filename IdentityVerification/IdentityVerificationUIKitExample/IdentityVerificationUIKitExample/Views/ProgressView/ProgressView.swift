//
//  ProgressView.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

class ProgressView: UIView, Nameable {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(ProgressView.defaultName, owner: self, options: nil)
        mainView.frame = self.bounds
        self.addSubview(mainView)
        loader.startAnimating()
    }
    
    func initView(title: String? = "", description: String? = "", imageName: String? = nil, showLoader: Bool = false) {
        statusTitle.text = title
        subTitle.text = description
        loader.isHidden = !showLoader
        icon.isHidden = showLoader
        guard let imageName = imageName else { return }
        icon.image = UIImage(named: imageName)
    }
}
