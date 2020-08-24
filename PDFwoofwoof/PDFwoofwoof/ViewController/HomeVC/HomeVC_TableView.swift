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
        return isRecent ? listRecent.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifier) as? DocumentTableViewCell else {
            return UITableViewCell()
        }
        cell.setData(pdf: listRecent[indexPath.row])
        return cell
    }
}

extension HomeVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pdfVC = storyboard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
//        pdfVC.config(with: isRecent ? listRecent[indexPath.row] : listFavorite[indexPath.row])
//        RealmManager.saveRecentPDF(url: isRecent ? listRecent[indexPath.row].url! : listFavorite[indexPath.row].url!) {
//            print("saved recent file")
//        }
        navigationController?.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(pdfVC, animated: true)
    }
}
