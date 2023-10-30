//
//  SeparatorLineView.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

class SeparatorLineView: UIView, Nameable {

    @IBOutlet var mainView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(SeparatorLineView.defaultName, owner: self, options: nil)
        mainView.frame = self.bounds
        self.addSubview(mainView)
    }

}
