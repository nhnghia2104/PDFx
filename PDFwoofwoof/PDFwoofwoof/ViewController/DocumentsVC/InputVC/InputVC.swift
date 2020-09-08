//
//  InputVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/8/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class InputVC: UIViewController {

    @IBOutlet weak var contentViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blackView: UIView!
    
    private var groupKey : [String] = [
        "IMPORT", "CREATE", "TOOL"
    ]
    private var groupTool : [String : [Tool]] = [
        "IMPORT" : [
            Tool(name: "Browse from Files", icon: UIImage(named: "ic_Home"), type: .browse)
        ],
        "CREATE" : [
            Tool(name: "Scan Document", icon: UIImage(named: "ic_Home"), type: .scan),
            Tool(name: "Create Folder", icon: UIImage(named: "ic_Home"), type: .createFolder),
            Tool(name: "Create PDF", icon: UIImage(named: "ic_Home"), type: .createPDF)
        ],
        "TOOL" : [
            Tool(name: "Merge", icon: UIImage(named: "ic_Home"), type: .merge)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InputCell", bundle: nil), forCellReuseIdentifier: "InputCell")
        tableView.register(UINib(nibName: "ToolInputCell", bundle: nil), forCellReuseIdentifier: "ToolInputCell")
        tableView.contentInset.top = tableView.contentInset.top + 10
//        contentViewHeightAnchor.constant = (CGFloat(listTool.count * 50 + 10) + 40 + (UIDevice.current.IS_169_RATIO() ? 0 : 20))
        
        addGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            [weak self] in
            self?.blackView.alpha = 0.5
        }
    }
    
    private func addGestureRecognizer() {
        
    }
    
    @IBAction func tapDismiss() {
        dismissInput()
    }
    private func dismissInput() {
        dismiss(animated: false, completion: nil)
    }

}
extension InputVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupKey.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupTool[groupKey[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if groupKey[indexPath.section] == "TOOL" {
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "ToolInputCell") as? ToolInputCell else {return UITableViewCell()}
            cell.config(tools: groupTool[groupKey[indexPath.section]]!)
            return cell
        }
        else {
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "InputCell") as? InputCell else {return UITableViewCell()}
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .zero)
        
        let lblTitle = UILabel()
        headerView.addSubview(lblTitle)
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        lblTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        
        lblTitle.font = UIFont.getFontRegular(size: 14)
        lblTitle.textColor = CMSConfigConstants.shared.themeStyle.tintGray
        lblTitle.text = groupKey[section]
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    


}
