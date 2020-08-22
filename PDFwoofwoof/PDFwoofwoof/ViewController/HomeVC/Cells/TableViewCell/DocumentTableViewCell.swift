//
//  DocumentListCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/15/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class DocumentTableViewCell: BaseTableViewCell {

    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var avtLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var trallingAnchor: NSLayoutConstraint!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var imgAvt: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnMore.tintColor = CMSConfigConstants.themeStyle.gray1
        lblTitle.font = UIFont.getFontOpenSans(style: .SemiBold, size: 15)
        lblSubTitle.font = UIFont.getFontOpenSans(style: .Regular, size: 13)
        lblTitle.textColor = CMSConfigConstants.themeStyle.black
        lblSubTitle.textColor = CMSConfigConstants.themeStyle.black
        
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.numberOfLines = 2
        vLine.backgroundColor = CMSConfigConstants.themeStyle.borderColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func tapMore(_ sender: Any) {
    }
    
    public func setData(title : String, sub : String, img : UIImage, isFavorite : Bool = false, isSelectMode : Bool = false) {
        self.imgSelect.isHidden = !isSelectMode
        self.avtLeadingAnchor.constant = isSelectMode ? 70 : 20
        
        self.imgStar.isHidden = !isFavorite
        self.trallingAnchor.constant = isFavorite ? 23 : 2
        
        self.imgAvt.image = img
        
        self.lblTitle.text = title
        self.lblSubTitle.text = sub
    }
    
}
