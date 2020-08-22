//
//  GridDocCollectionViewCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/21/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class GridDocCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgStar.isHidden = true
        imgSelect.isHidden = true
        lblSubTitle.font = UIFont.getFontOpenSans(style: .Regular, size: 12)
        lblTitle.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        lblSubTitle.textColor = CMSConfigConstants.themeStyle.black
        lblTitle.textColor = CMSConfigConstants.themeStyle.black
        
        lblTitle.lineBreakMode = .byTruncatingTail
        lblTitle.numberOfLines = 2
        
        imgThumbnail.layer.borderColor = CMSConfigConstants.themeStyle.borderColor.cgColor
        vBackground.backgroundColor = UIColor(hex: "f1f3f4")
    }

    public func setDocuemtData(pdf : MyPDFDocument, isFavorite : Bool = false, isSelectMode : Bool = false) {
        if let page1 = pdf.data!.page(at: 0) {
            imgThumbnail.image = page1.thumbnail(of: CGSize(width: imgThumbnail.frame.size.width,height: imgThumbnail.frame.size.height), for: .artBox)
        }
        
        imgThumbnail.layer.borderWidth = 2

        
        imgSelect.isHidden = !isSelectMode
      
        
        imgStar.isHidden = !isFavorite
        
        self.lblTitle.text = pdf.data?.documentURL?.lastPathComponent ?? ""
        self.lblSubTitle.text = pdf.strDateModifed
    }
    
    public func setFolderData(folder : MyFolder) {
        lblTitle.text = folder.url.lastPathComponent
        lblSubTitle.text = ""
        imgThumbnail.image = UIImage(named : "ic_folder")
        imgThumbnail.tintColor = CMSConfigConstants.themeStyle.gray1
        
        imgThumbnail.layer.borderWidth = 0
    }
}
