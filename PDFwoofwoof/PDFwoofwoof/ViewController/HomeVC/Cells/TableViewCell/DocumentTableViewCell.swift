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
    @IBOutlet weak var imgThumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnMore.tintColor = CMSConfigConstants.shared.themeStyle.tintColor
        lblTitle.font = UIFont.getFontOpenSans(style: .SemiBold, size: 15)
        lblSubTitle.font = UIFont.getFontOpenSans(style: .Regular, size: 13)
        lblTitle.textColor = CMSConfigConstants.shared.themeStyle.titleColor
        lblSubTitle.textColor = CMSConfigConstants.shared.themeStyle.titleColor
        
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.numberOfLines = 2
        vLine.backgroundColor = CMSConfigConstants.shared.themeStyle.borderColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func tapMore(_ sender: Any) {
    }
    
    public func setData(pdf : MyDocument,isFavorite : Bool = false, isSelectMode : Bool = false) {
        self.imgSelect.isHidden = !isSelectMode
        self.avtLeadingAnchor.constant = isSelectMode ? 70 : 20
        
        self.imgStar.isHidden = !isFavorite
        self.trallingAnchor.constant = isFavorite ? 23 : 2
       
        self.lblTitle.text = pdf.getFileName()
        self.lblSubTitle.text = pdf.getStrDateTimeCreated()
        self.imgThumbnail.image = pdf.getThumbnail()
    }
    
}
