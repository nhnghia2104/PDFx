//
//  EmptyView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/25/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.getFontBold(size: 16)
        lblMessage.font = UIFont.getFontRegular(size: 14)
        lblTitle.textColor = CMSConfigConstants.themeStyle.tintColor
        lblMessage.textColor = CMSConfigConstants.themeStyle.tintColor
        lblMessage.alpha = 0.8
        imgImage.tintColor = CMSConfigConstants.themeStyle.tintColor
        imgImage.alpha = 0.8
        
        lblTitle.textAlignment = .center
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 2
    }
    public func setData(title : String, message : String, image : UIImage) {
        lblTitle.text = title
        lblMessage.text = message
        imgImage.image = image
    }
}
