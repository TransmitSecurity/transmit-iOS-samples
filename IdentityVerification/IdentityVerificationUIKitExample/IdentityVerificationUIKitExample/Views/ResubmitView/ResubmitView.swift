//
//  ResubmitView.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

class ResubmitView: UIView, Nameable {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var documentsTitle: UILabel!
    @IBOutlet weak var documentTableView: UITableView!
    private var documentData = [GenericTableViewCellModel]()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(ResubmitView.defaultName, owner: self, options: nil)
        mainView.frame = self.bounds
        self.addSubview(mainView)
        initDefaults()
    }
    
    private func initDefaults() {
        documentTableView.register(GenericTableViewCell.nib(), forCellReuseIdentifier: GenericTableViewCell.identifier)
        documentTableView.delegate = self
        documentTableView.dataSource = self
        documentTableView.separatorStyle = .none
        documentTableView.isScrollEnabled = false
    }
    
    func initView(title: String, description: String, subDescription: String, documentData: [GenericTableViewCellModel] ) {
        statusTitle.text = title
        subTitle.text = description
        documentsTitle.text = subDescription
        documentsTitle.isHidden = subDescription.isEmpty
        self.documentData = documentData
        documentTableView.reloadData()
    }

}

extension ResubmitView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.identifier, for: indexPath) as! GenericTableViewCell
        cell.initCell(cell: documentData[indexPath.row])
        return cell
    }
    
}
