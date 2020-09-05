//
//  SearchResultCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/1/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblContent.font = UIFont.getFontRegular(size: 14)
        lblIndex.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
        lblContent.textColor = CMSConfigConstants.themeStyle.titleColor
        lblIndex.textColor = CMSConfigConstants.themeStyle.titleColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(selection : PDFSelection, pageIndex : Int) {
        let page = selection.pages[0]
        imgThumbnail.image = page.thumbnail(of: CGSize(width: imgThumbnail.frame.width, height: imgThumbnail.frame.height), for: .cropBox)
        lblIndex.text = "\(pageIndex)"
        
        let extendSelection = selection.copy() as! PDFSelection
        extendSelection.extend(atStart: 10)
        extendSelection.extend(atEnd: 90)
        extendSelection.extendForLineBoundaries()
        
        let range = (extendSelection.string! as NSString).range(of: selection.string!, options: .caseInsensitive)
        let attrstr = NSMutableAttributedString(string: extendSelection.string!)
        attrstr.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
        lblContent.attributedText = attrstr
    }
    
}
