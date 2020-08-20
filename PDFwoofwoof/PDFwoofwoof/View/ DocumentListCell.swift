//
//  DocumentListCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/15/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class DocumentListCell: BaseTableViewCell {

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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func tapMore(_ sender: Any) {
    }
    
    public func setData(title : String, sub : String, img : UIImage, isFavorite : Bool) {
        
    }
    
}
