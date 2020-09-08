//
//  LeftMenuVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/12/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case home = 0
    case files
    case settings
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuVC : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Home", "Documents","Settings"]
    var mainViewController: UIViewController!
    var documentVC: UIViewController!
//    var javaViewController: UIViewController!
//    var goViewController: UIViewController!
//    var nonMenuViewController: UIViewController!
    private var lastSelect : IndexPath?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    private func initView() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        documentVC = storyboard.instantiateViewController(withIdentifier: "DocumentsVC") as! DocumentsVC
        self.documentVC = UINavigationController(rootViewController: documentVC)
        mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        lblMenu.font = UIFont.getFontBold(size: 30)
        lblMenu.textColor = CMSConfigConstants.shared.themeStyle.titleColor
        
        
    }
    
    private func setupTableView() {
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        
        self.tableView.registerCellNib(LeftMenuTableViewCell.self)
        self.tableView.allowsMultipleSelection = false
        
        if UserDefaults.standard.object(forKey: "MainView") == nil {
            UserDefaults.standard.setValue(1, forKey: "MainView")
        }
        if let key = UserDefaults.standard.object(forKey: "MainView") as? Int {
            self.tableView.selectRow(at: IndexPath(row: key, section: 0), animated: false, scrollPosition: .none)
        }
        
        
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
            UserDefaults.standard.setValue(0, forKey: "MainView")
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .files:
            UserDefaults.standard.setValue(1, forKey: "MainView")
             self.slideMenuController()?.changeMainViewController(self.documentVC, close: true)
        default:
            break
        }
    }
}
extension LeftMenuVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: LeftMenuTableViewCell.identifier) as? LeftMenuTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setTilte(str: menus[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
extension LeftMenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
        tableView.deselectRow(at: lastSelect ?? indexPath, animated: false)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        lastSelect = indexPath
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
