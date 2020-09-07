//
//  GridDocCollectionViewCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/21/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit

class GridDocCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    override var isSelected: Bool {
        didSet {
            imgSelect.image = isSelected ? UIImage(named: "ic_Check") : UIImage(named: "ic_Circle")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imgStar.isHidden = true
        imgSelect.isHidden = true
        lblTitle.font = UIFont.getFontOpenSans(style: .SemiBold, size: isiPadUI ? 16 : 14)
        lblSubTitle.font = UIFont.getFontOpenSans(style: .Regular, size: isiPadUI ? 13 : 12)
        lblSubTitle.textColor = CMSConfigConstants.themeStyle.titleColor
        lblTitle.textColor = CMSConfigConstants.themeStyle.titleColor
        
        lblTitle.lineBreakMode = .byTruncatingMiddle
        lblTitle.numberOfLines = 2
        
        imgThumbnail.layer.borderColor = CMSConfigConstants.themeStyle.borderColor.cgColor
        vBackground.backgroundColor = UIColor(hex: "f1f3f4")
        imgStar.tintColor = CMSConfigConstants.themeStyle.tintBlue
    }
    
    public func setDocuemtData(pdf : MyDocument, isFavorite : Bool = false, isSelectMode : Bool = false) {

            imgThumbnail.layer.borderWidth = isiPadUI ? 2 : 1
            imgSelect.isHidden = !isSelectMode
            imgStar.isHidden = !isFavorite
            
            imgThumbnail.image = pdf.getThumbnail()
            lblTitle.text = pdf.getFileName()
            lblSubTitle.text = pdf.getStrDateCreated()

    }
    
    public func setFolderData(folder : MyFolder, isSelectMode : Bool = false) {
        imgStar.isHidden = true
        imgSelect.isHidden = true
        lblTitle.text = folder.url.lastPathComponent
        lblSubTitle.text = ""
        imgThumbnail.image = UIImage(named : "ic_folder")
        imgThumbnail.tintColor = CMSConfigConstants.themeStyle.tintColor
        
        imgThumbnail.layer.borderWidth = 0
    }

}
