//
//  ToolCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/13/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class ToolCell: UICollectionViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblToolName: UILabel!
    @IBOutlet weak var vBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        vBackground.layer.cornerRadius = 5.0
        lblToolName.font = UIFont.getFontOpenSans(style: .Regular, size: 13)
        lblToolName.textColor = CMSConfigConstants.themeStyle.tintColor
    }
    
    func setData(tool : Tool) {
        self.imgIcon.image = tool.icon
        self.lblToolName.text = tool.name
        self.imgIcon.tintColor = tool.tintColor
        self.vBackground.backgroundColor = tool.backgroundColor
    }

}
