//
//  InputVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/8/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class InputVC: UIViewController {

    @IBOutlet weak var contentViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blackView: UIView!
    var openTool : ((TypeTool)->())?
    private var groupKey : [String] = [
        "IMPORT", "CREATE", "TOOL"
    ]
    private var groupTool : [String : [Tool]] = [
        "IMPORT" : [
            Tool(name: "Browse from Files", icon: UIImage(named: "ic_Home"), type: .browse)
        ],
        "CREATE" : [
            Tool(name: "Scan", icon: UIImage(named: "ic_Home"), type: .scan),
            Tool(name: "New Folder", icon: UIImage(named: "ic_Home"), type: .createFolder),
            Tool(name: "New PDF", icon: UIImage(named: "ic_Home"), type: .createPDF)
        ],
        "TOOL" : [
            Tool(name: "Merge", icon: UIImage(named: "ic_Home"), type: .merge),
            Tool(name: "Merge", icon: UIImage(named: "ic_Home"), type: .merge),
            Tool(name: "Merge", icon: UIImage(named: "ic_Home"), type: .merge),
            Tool(name: "Merge", icon: UIImage(named: "ic_Home"), type: .merge),
            Tool(name: "Merge", icon: UIImage(named: "ic_Home"), type: .merge),
            Tool(name: "Merge", icon: UIImage(named: "ic_Home"), type: .merge),
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
            
        /**
         header = 35
         content inset top = 10
         height for row at section 1 and 2 = 50
         height for row at section 3 = 120
         footer = 40
                **/
        contentViewHeightAnchor.constant = 500
        contentViewBottomAnchor.constant = -500
        addGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            [weak self] in
            self?.blackView.alpha = 0.5
            self?.contentViewBottomAnchor.constant = -40
            self?.view.layoutIfNeeded()
        }
    }
    
    private func addGestureRecognizer() {
        
    }
    
    
    @IBAction func tapDismiss() {
        
        dismissInput()
    }
    private func dismissInput(completion:(()->())? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            [weak self] in
            self?.blackView.alpha = 0
            self?.contentViewBottomAnchor.constant = -500
            self?.view.layoutIfNeeded()
        }) { [weak self](done) in
            if done {
                self?.dismiss(animated: false, completion: nil)
                completion?()
            }
        }
       
    }
    
    private func didSelect(indexPath : IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? InputCell else {
            return
        }
        dismissInput {
            [weak self] in
            self?.openTool!(cell.getType())
        }
    }

}
extension InputVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupKey.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupKey[section] == "TOOL" {
            return 1
        }
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
            if let tools = groupTool[groupKey[indexPath.section]]{
                cell.setData(tool: tools[indexPath.row])
            }
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
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if groupKey[indexPath.section] == "TOOL" {
            return 120
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(indexPath: indexPath)
    }

}
