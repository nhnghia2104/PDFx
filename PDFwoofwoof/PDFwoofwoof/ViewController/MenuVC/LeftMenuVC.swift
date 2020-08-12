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
    case search
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
    var swiftViewController: UIViewController!
    var javaViewController: UIViewController!
    var goViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        self.tableView.registerCellNib(LeftMenuTableViewCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
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
