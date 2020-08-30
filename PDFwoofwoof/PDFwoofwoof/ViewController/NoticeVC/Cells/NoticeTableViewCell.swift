//
//  NoticeTableViewCell.swift
//  PDFwoofwoof
//
//  Created by Minh on 8/28/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTimeNoticeSent: UILabel!
    @IBOutlet weak var vLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMessage.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        lblTimeNoticeSent.font = UIFont.getFontOpenSans(style: .Regular, size: 11)
        lblMessage.textColor = CMSConfigConstants.themeStyle.titleColor
        lblTimeNoticeSent.textColor = .darkGray
        lblMessage.numberOfLines = 2
        vLine.backgroundColor = CMSConfigConstants.themeStyle.borderColor
    }

    func setData(noti : Notice) {
        self.imgIcon.image = noti.img
        self.lblMessage.text = noti.message
        self.lblTimeNoticeSent.text = noti.timeSent
    }
    
}
