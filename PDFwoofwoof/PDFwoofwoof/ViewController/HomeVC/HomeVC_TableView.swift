//
//  HomeVC_TableView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/14/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//
import UIKit
extension HomeVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       /**
        1. advertisement
        2. recent documents
        3. favorite documents
        */
        return shouldHaveAds ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return shouldHaveAds ? 1 : (listRecent.count + 1)
        case 1:
            return shouldHaveAds ? (listRecent.count + 1): (listFavorite.count + 1)
        case 2:
            return listFavorite.count + 1
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            /**
                have advertisement :
                        - section 0 = AdvertiseCell
                have not advertisement :
                        - section 0 = recents
                            + documents cell
                            + see more recents doc
            */
            if shouldHaveAds {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AdvertiseCell.identifier) as? AdvertiseCell else {
                    return UITableViewCell()
                }
                return cell
            }
            else {
                if indexPath.row == listRecent.count {
                    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SeeMoreCell.identifier) as? SeeMoreCell else {
                        return UITableViewCell()
                    }
                    cell.setText(str: "More recent documents")
                    return cell
                }
                else {
                    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: DocumentListCell.identifier) as? DocumentListCell else {
                        return UITableViewCell()
                    }
                    return cell
                }
            }
            
        case 1:
            /**
             have advertisement :
             - section 1 =  recent
             + documents cell
             + see more recents doc
             have not advertisement :
             - section 1 = favorite
             + documents cell
             + see more favorite doc
             */
            
            
            if indexPath.row == (shouldHaveAds ? listRecent.count : listFavorite.count) {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SeeMoreCell.identifier) as? SeeMoreCell else {
                    return UITableViewCell()
                }
                cell.setText(str: shouldHaveAds ? "More recent documents" : "More favorite documents")
                return cell
            }
            else {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: DocumentListCell.identifier) as? DocumentListCell else {
                    return UITableViewCell()
                }
                return cell
            }
            
            
        case 2:
            /**
                - section 2 = favorite
                    + documents cell
                    + see more favorite doc
            */
            if indexPath.row == listFavorite.count {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SeeMoreCell.identifier) as? SeeMoreCell else {
                    return UITableViewCell()
                }
                cell.setText(str: "More favorite documents")
                return cell
            }
            else {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: DocumentListCell.identifier) as? DocumentListCell else {
                    return UITableViewCell()
                }
                return cell
            }
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .zero)
        let lbl = UILabel()
        lbl.font = UIFont.getFontOpenSans(style: .Regular, size: 14)
        lbl.textColor = CMSConfigConstants.themeStyle.gray1
        headerView.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        lbl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        switch section {
        case 0:
            lbl.text = shouldHaveAds ? "" : "Recent Documents"
            break
        case 1:
            lbl.text = shouldHaveAds ? "Recent Documents" : "Favorite Documents"
            break
        case 2:
            lbl.text = "Favorite Documents"
            break
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    

}

extension HomeVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            break
        case 2:
            break
        default:
            break
        }
        return 70
    }
}
