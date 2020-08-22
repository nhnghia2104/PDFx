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
    @IBOutlet weak var imgAvt: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgStar.isHidden = true
        imgSelect.isHidden = true
        
        btnMore.tintColor = CMSConfigConstants.themeStyle.gray1
        lblTitle.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        lblSubTitle.font = UIFont.getFontOpenSans(style: .Regular, size: 12)
        lblTitle.textColor = CMSConfigConstants.themeStyle.black
        lblSubTitle.textColor = CMSConfigConstants.themeStyle.black
        
        lblTitle.lineBreakMode = .byTruncatingMiddle
        lblTitle.numberOfLines = 2
        
        avtLeadingAnchor.constant = 20
        trallingAnchor.constant = 2
        
        imgAvt.layer.borderColor = CMSConfigConstants.themeStyle.borderColor.cgColor
        vLine.backgroundColor = CMSConfigConstants.themeStyle.borderColor
        
    }

    @IBAction func tapMore(_ sender: Any) {
    }
    
    public func setDocuemtData(pdf : MyPDFDocument, isFavorite : Bool = false, isSelectMode : Bool = false) {
        if let page1 = pdf.data!.page(at: 0) {
            imgAvt.image = page1.thumbnail(of: CGSize(width: imgAvt.frame.size.width,height: imgAvt.frame.size.height), for: .artBox)
        }
        
        imgAvt.layer.borderWidth = 1.5
        
        imgSelect.isHidden = !isSelectMode
        avtLeadingAnchor.constant = isSelectMode ? 70 : 20
        
        imgStar.isHidden = !isFavorite
        trallingAnchor.constant = isFavorite ? 23 : 2
        
        self.lblTitle.text = pdf.data?.documentURL?.lastPathComponent ?? ""
        self.lblSubTitle.text = pdf.strDateModifed + "\t" + pdf.strSize
    }
    
    public func setFolderData(folder : MyFolder) {
        lblTitle.text = folder.url.lastPathComponent
        lblSubTitle.text = ""
        imgAvt.image = UIImage(named : "ic_folder")
        imgAvt.tintColor = CMSConfigConstants.themeStyle.gray1
        
        imgAvt.layer.borderWidth = 0
    }
}
