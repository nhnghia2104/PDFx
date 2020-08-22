//
//  HomeVC_TableView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/14/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//
import UIKit
extension HomeVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifier) as? DocumentTableViewCell else {
            return UITableViewCell()
        }
        cell.setData(title: "Abc", sub: "2020-04-21", img: UIImage(named: "ic_folder")!)
        return cell
    }
}

extension HomeVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
