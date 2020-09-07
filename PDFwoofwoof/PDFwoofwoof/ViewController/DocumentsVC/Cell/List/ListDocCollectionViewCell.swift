//
//  ListDocCollectionViewCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/21/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit
import SwipeCellKit

class ListDocCollectionViewCell: SwipeCollectionViewCell {
    
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var avtLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var trallingAnchor: NSLayoutConstraint!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    var isFavorite = false {
        didSet {
            UIView.animate(withDuration: 0.2) {[weak self] in
                self?.imgStar.isHidden = !self!.isFavorite
                self?.trallingAnchor.constant = self!.isFavorite ? 23 : 2
                self?.layoutIfNeeded()
            }
            
        }
    }
    var isExpanding = false {
        didSet {
            btnMore.isHidden = isExpanding
        }
    }
    override var isSelected: Bool {
        didSet {
            imgSelect.image = isSelected ? UIImage(named: "ic_Check") : UIImage(named: "ic_Circle")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgStar.isHidden = true
        imgSelect.isHidden = true
        
        btnMore.tintColor = CMSConfigConstants.themeStyle.tintGray
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
        imgStar.tintColor = CMSConfigConstants.themeStyle.tintBlue
//        imgSelect.layer.cornerRadius = 15.0
//        imgSelect.layer.borderColor = CMSConfigConstants.themeStyle.borderColor.cgColor
//        imgSelect.layer.borderWidth = 2.0
    }
    
    @IBAction func tapMore(_ sender: Any) {
        self.showSwipe(orientation: .right)
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
        imgStar.isHidden = true
        lblTitle.text = folder.url.lastPathComponent
        lblSubTitle.text = ""
        imgThumbnail.image = UIImage(named : "ic_folder")
        imgThumbnail.tintColor = CMSConfigConstants.themeStyle.tintColor
        btnMore.isHidden = isSelectMode
        imgSelect.isHidden = true
        avtLeadingAnchor.constant = isSelectMode ? 70 : 20
        imgThumbnail.layer.borderWidth = 0
    }
    
    public func setRecentData(pdf : MyDocument, isFavorite : Bool = false) {
        imgThumbnail.layer.borderWidth = 1
        imgStar.isHidden = !isFavorite
        trallingAnchor.constant = isFavorite ? 23 : 2
        
        lblTitle.text = pdf.getFileName()
        lblSubTitle.text = pdf.getStrAccessDate() + "\t" + pdf.getStrSize()
        imgThumbnail.image = pdf.getThumbnail()
    }
}
