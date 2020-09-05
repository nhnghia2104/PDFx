//
//  LeftMenuTableViewCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/12/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var vSelect: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgIcon.tintColor = CMSConfigConstants.themeStyle.tintColor
        lblTitle.tintColor = CMSConfigConstants.themeStyle.tintColor
        lblTitle.font = UIFont.getFontOpenSans(style: .Regular, size: 14)
        vSelect.backgroundColor = CMSConfigConstants.themeStyle.borderColor
        vSelect.alpha = 0.5
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
//            imgIcon.tintColor =  CMSConfigConstants.themeStyle.selectColor
//            lblTitle.textColor = CMSConfigConstants.themeStyle.selectColor
            lblTitle.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
//            line.backgroundColor = CMSConfigConstants.themeStyle.selectColor
            line.alpha = 1.0
            vSelect.isHidden = false
        }
        else {
//            imgIcon.tintColor =  CMSConfigConstants.themeStyle.tintColor
//            lblTitle.textColor = CMSConfigConstants.themeStyle.tintColor
            lblTitle.font = UIFont.getFontOpenSans(style: .Regular, size: 14)
//            line.backgroundColor = UIColor.lightGray
            line.alpha = 0.5
            vSelect.isHidden = true
        }
    }
    
    public func setTilte(str : String) {
        lblTitle.text = str
        imgIcon.image = UIImage(named: "ic_\(str)") ?? UIImage()
    }
    public func setSelect(isSelected : Bool) {
        imgIcon.tintColor = isSelected ? CMSConfigConstants.themeStyle.selectColor : CMSConfigConstants.themeStyle.tintColor
        lblTitle.tintColor = isSelected ? CMSConfigConstants.themeStyle.selectColor : CMSConfigConstants.themeStyle.tintColor
    }
    
}
