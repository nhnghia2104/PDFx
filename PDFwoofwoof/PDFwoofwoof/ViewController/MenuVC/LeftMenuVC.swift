//
//  LeftMenuVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/12/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case search = 0
    case home
    case document
    case starred
    case recent
    case settings
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuVC : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Search", "Home", "Documents", "Starred", "Recent","Settings"]
    var mainViewController: UIViewController!
    var documentVC: UIViewController!
    var javaViewController: UIViewController!
    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    private var lastSelect : IndexPath?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let documentVC = storyboard.instantiateViewController(withIdentifier: "DocumentsVC") as! DocumentsVC
        self.documentVC = UINavigationController(rootViewController: documentVC)
        self.tableView.registerCellNib(LeftMenuTableViewCell.self)
        self.tableView.allowsMultipleSelection = false
        self.tableView.selectRow(at: IndexPath(row: LeftMenu.home.rawValue, section: 0), animated: false, scrollPosition: .none)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .document:
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
