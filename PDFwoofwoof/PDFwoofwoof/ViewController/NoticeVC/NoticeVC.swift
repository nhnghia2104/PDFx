//
//  NoticeVC.swift
//  PDFwoofwoof
//
//  Created by Minh on 8/28/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class NoticeVC: UIViewController {

    @IBOutlet weak var tbvNotice: UITableView!
    
    var listNotice: [Notice] = [
        Notice(message: "Điểm sàn sẽ được công bố sau khi có điểm thi tốt nghiệp THPT đợt 2", timeSent: "Today", img: UIImage(named: "ic_Appicon")!),
       Notice(message: "Bộ công an bắt giam chủ tịch TP.Hà Nội Nguyễn Đức Trung", timeSent: "2 days ago", img: UIImage(named: "ic_Appicon")!),
       Notice(message: "Phiên bản mới đã sẵn sàng, mời bạn cập nhập", timeSent: "1 day ago", img: UIImage(named: "ic_Appicon")!),
    ]
    // MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setupNavigation()
    }


    /// MARK: - setup functions
    private func setupNavigation() {
        
        self.navigationItem.title = "Notifications"
        self.addRightBarButtonWithTittle(title: "Done", action: #selector(tapBack))
        setupBaseNavigation()
    }
    
    private func register() {
        tbvNotice.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeTableViewCell")
    }
    
    // MARK: - @objc function
    @objc func tapBack() {
        goToHome()
    }
    
    //MARK: - Action Function
    private func goToHome() {
        self.dismiss(animated: true, completion: nil)
    }

}


extension NoticeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listNotice.count == 0 {
            tableView.setEmptyView(title: "No Notification", message: "", image: UIImage(named: "image_noRecent")!)
        }
        return listNotice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView
       .dequeueReusableCell(withIdentifier: "NoticeTableViewCell") as? NoticeTableViewCell else {return UITableViewCell()}
        cell.setData(noti: listNotice[indexPath.row])
        return cell
    }
    
}


extension NoticeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var height: CGFloat = CGFloat()
//        height = tbvNotice.frame.height / 7
        return 100
    }
}
