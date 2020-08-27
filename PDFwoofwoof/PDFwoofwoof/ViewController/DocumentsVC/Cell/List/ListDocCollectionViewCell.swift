//
//  ListDocCollectionViewCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/21/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit

class ListDocCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var avtLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var trallingAnchor: NSLayoutConstraint!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgStar.isHidden = true
        imgSelect.isHidden = true
        
        btnMore.tintColor = CMSConfigConstants.themeStyle.tintColor
        lblTitle.font = UIFont.getFontOpenSans(style: .SemiBold, size: isiPadUI ? 16 : 14)
        lblSubTitle.font = UIFont.getFontOpenSans(style: .Regular, size: isiPadUI ? 13 : 12)
        lblTitle.textColor = CMSConfigConstants.themeStyle.titleColor
        lblSubTitle.textColor = CMSConfigConstants.themeStyle.titleColor
        
        lblTitle.lineBreakMode = .byTruncatingMiddle
        lblTitle.numberOfLines = 2
        
        avtLeadingAnchor.constant = 20
        trallingAnchor.constant = 2
        
        imgThumbnail.layer.borderColor = CMSConfigConstants.themeStyle.borderColor.cgColor
        vLine.backgroundColor = CMSConfigConstants.themeStyle.borderColor
        
    }
    
    @IBAction func tapMore(_ sender: Any) {
    }
    
    public func setDocuemtData(pdf : MyDocument, isFavorite : Bool = false, isSelectMode : Bool = false) {
        
        imgThumbnail.layer.borderWidth = 1
        imgSelect.isHidden = !isSelectMode
        avtLeadingAnchor.constant = isSelectMode ? 70 : 20
        btnMore.isHidden = isSelectMode
        imgStar.isHidden = !isFavorite
        trallingAnchor.constant = isFavorite ? 23 : 2
        
        lblTitle.text = pdf.getFileName()
        lblSubTitle.text = pdf.getStrDateTimeCreated() + pdf.getStrSize()
        imgThumbnail.image = pdf.getThumbnail()
        
        
    }
    public func setFolderData(folder : MyFolder, isSelectMode : Bool = false) {
        lblTitle.text = folder.url.lastPathComponent
        lblSubTitle.text = ""
        imgThumbnail.image = UIImage(named : "ic_folder")
        imgThumbnail.tintColor = CMSConfigConstants.themeStyle.tintColor
        btnMore.isHidden = isSelectMode
        imgSelect.isHidden = !isSelectMode
        avtLeadingAnchor.constant = isSelectMode ? 70 : 20
        imgThumbnail.layer.borderWidth = 0
    }
}
