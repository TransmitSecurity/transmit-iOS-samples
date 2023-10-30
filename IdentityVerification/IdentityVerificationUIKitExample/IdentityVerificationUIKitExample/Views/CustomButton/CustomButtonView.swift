//
//  CustomButtonView.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

protocol CustomButtonViewDelegate: NSObject {
    func clicked()
}

class CustomButtonView: UIView, Nameable {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var button: UIButton!
    fileprivate weak var delegate : CustomButtonViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(CustomButtonView.defaultName, owner: self, options: nil)
        mainView.frame = self.bounds
        self.addSubview(mainView)
        self.button.layer.cornerRadius = 4
    }
    
    public func initView(isEnable: Bool, buttonText: String, listener: CustomButtonViewDelegate? = nil) {
        self.button.setTitle(buttonText, for: .normal)
        self.delegate = listener
        toggleButton(isEnable: isEnable)
    }
    
    public func updateButtonText(buttonText: String) {
        button.setTitle(buttonText, for: .normal)
    }
    
    public func toggleButton(isEnable: Bool) {
        self.button.backgroundColor = isEnable ? Constants.Colors.primaryBlue : Constants.Colors.primaryGrey
        self.button.isEnabled = isEnable
    }
    
    @IBAction func clicked(_ sender: Any) {
        self.delegate?.clicked()
    }
}
