//
//  CheckboxView.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

protocol CheckboxViewDelegate: NSObject {
    func clicked(clicked: Bool)
}

class CheckboxView: UIView, Nameable {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var image: UIImageView!
    fileprivate(set) var onClicked = false
    fileprivate weak var delegate : CheckboxViewDelegate?
    
    enum CheckBoxState {
        case onChecked
        case onUnchecked
                
        var image: UIImage {
            get {
                switch self {
                case .onChecked:
                    return UIImage(named: "ic_checkbox")!
                case .onUnchecked:
                    return UIImage(named: "ic_uncheckbox")!
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(CheckboxView.defaultName, owner: self, options: nil)
        mainView.frame = self.bounds
        self.addSubview(mainView)
        toggleCheckboxState()
    }
    
    private func checkboxClicked() {
        self.onClicked = !self.onClicked
        toggleCheckboxState()
    }
    
    private func toggleCheckboxState() {
        self.image.image = self.onClicked ? CheckBoxState.onChecked.image : CheckBoxState.onUnchecked.image
    }
    
    public func initView(listener: CheckboxViewDelegate? = nil) {
        self.delegate = listener
    }
    
    
    @IBAction func checkboxClicked(_ sender: Any) {
        self.checkboxClicked()
        self.delegate?.clicked(clicked: self.onClicked)
    }
}
