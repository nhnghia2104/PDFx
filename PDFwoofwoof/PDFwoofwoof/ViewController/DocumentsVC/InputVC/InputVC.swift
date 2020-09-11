//
//  InputVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/8/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class InputVC: UIViewController {

    // NSLayoutConstraint
    @IBOutlet weak var vContentWidth: NSLayoutConstraint!
    @IBOutlet weak var vContentCenterX: NSLayoutConstraint!
    @IBOutlet weak var vContentCenterY: NSLayoutConstraint!
    @IBOutlet weak var vContentTrailing: NSLayoutConstraint!
    @IBOutlet weak var vContentLeading: NSLayoutConstraint!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var contentViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blackView: UIView!
    var defaultCenterY : CGFloat = -1
    var openTool : ((TypeTool)->())?
    private var groupKey : [String] = [
        "IMPORT", "CREATE", "TOOL"
    ]
    
    private var groupTool : [String : [Tool]] = [
        "IMPORT" : [
            Tool(name: "Browse from Files", icon: UIImage(named: "ic_Browser"), type: .browse)
        ],
        "CREATE" : [
            Tool(name: "Scan", icon: UIImage(named: "ic_Scan"), type: .scan),
            Tool(name: "New Folder", icon: UIImage(named: "ic_NewFolder"), type: .createFolder),
            Tool(name: "New PDF", icon: UIImage(named: "ic_NewPDF"), type: .createPDF)
        ],
        "TOOL" : [
            Tool(name: "Sign", icon: UIImage(named: "ic_Sign-mini"), type: .sign, color:  UIColor(hex: "FB5607", alpha: 0.15)),
            Tool(name: "Split", icon: UIImage(named: "ic_Split-mini"), type: .split, color: UIColor(hex: "D90429", alpha: 0.15)),
            Tool(name: "Merge", icon: UIImage(named: "ic_Merge-mini"), type: .merge, color: UIColor(hex: "9336FD", alpha: 0.15)),
            Tool(name: "Extract Page", icon: UIImage(named: "ic_Extract-mini"), type: .extract, color: UIColor(hex: "0077B6", alpha: 0.15)),
            Tool(name: "Organize Page", icon: UIImage(named: "ic_Organize-mini"), type: .organize, color:  UIColor(hex: "FFAB00", alpha: 0.15)),
            Tool(name: "Set Password", icon: UIImage(named: "ic_SetPass-Mini"), type: .setPassword, color:  UIColor(hex: "2B9348", alpha: 0.15)),
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InputCell", bundle: nil), forCellReuseIdentifier: "InputCell")
        tableView.register(UINib(nibName: "ToolInputCell", bundle: nil), forCellReuseIdentifier: "ToolInputCell")
        
        if !isiPadUI {
            contentViewBottomAnchor.constant = -500
        }
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
    
    override func viewWillLayoutSubviews() {

        if isiPadUI {
            setupLayout()
        }
    }
    
    private func setupLayout() {
        /**
                if is ipad UI -> remove bottom, leading and trailing constraint,
         -> add centerY, CenterX, Width
         */
        if isiPadUI {

            contentViewBottomAnchor.isActive = false
            vContentTrailing.isActive = false
            vContentLeading.isActive = false
            
            vContentCenterX.isActive = true
            vContentCenterY.isActive = true
            vContentWidth.isActive = true
            self.view.layoutIfNeeded()
            /**
             header = 35
             height for row at section 1 and 2 = 50
             height for row at section 3 = 120
             footer = 40
                    **/
            // set bottom for animate present
        }
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if isiPadUI { return }
        guard let recognizerView = recognizer.view else {
            return
        }
        if defaultCenterY == -1 {
            defaultCenterY = recognizerView.center.y
        }
        let translation = recognizer.translation(in: view)
        switch recognizer.state {
        case .began, .changed:
            
            if recognizerView.center.y + translation.y > defaultCenterY {
                recognizerView.center.y += translation.y
                recognizer.setTranslation(.zero, in: view)
                self.view.layoutIfNeeded()
            }
            
        case .ended:
            if view.frame.maxY - (recognizerView.center.y + translation.y) <= 0 {
                dismissInput()
            }else {
                UIView.animate(withDuration: 0.2) {
                    [weak self] in
                    recognizerView.center.y = self?.defaultCenterY ?? 0
                    self?.view.layoutIfNeeded()
                }
                
            }
            break
        default:
            break
        }
    }
    @IBAction func tapDismiss() {
        
        dismissInput()
    }
    private func dismissInput(completion:(()->())? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            [weak self] in
            self?.blackView.alpha = 0
            self?.vContent.alpha = 0
            if isiPadUI == false {
                self?.contentViewBottomAnchor.constant = -500
            }
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
