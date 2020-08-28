//
//  HeaderHomeView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/27/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class HeaderHomeView: UICollectionReusableView {
    @IBOutlet weak var vLineUnder: UIView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnRecent: UIButton!
    @IBOutlet weak var lineLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var vLine: UIView!
    var valueDidChange : ((Bool)->())?
    private var isRecent = true {
        didSet {
            btnRecent.titleLabel?.font = isRecent ? UIFont.getFontOpenSans(style: .SemiBold, size: 14) : UIFont.getFontOpenSans(style: .Regular, size: 14)
            btnFavorite.titleLabel?.font = isRecent ? UIFont.getFontOpenSans(style: .Regular, size: 14) : UIFont.getFontOpenSans(style: .SemiBold, size: 14)
            btnRecent.alpha = isRecent ? 1.0 : 0.7
            btnFavorite.alpha = isRecent ? 0.7 : 1.0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTheme()
    }
    private func setupTheme() {
        vLineUnder.backgroundColor = CMSConfigConstants.themeStyle.titleColor
        vLine.backgroundColor = CMSConfigConstants.themeStyle.borderColor
        btnRecent.setTitleColor(CMSConfigConstants.themeStyle.titleColor, for: .normal)
        btnFavorite.setTitleColor(CMSConfigConstants.themeStyle.titleColor, for: .normal)
        btnFavorite.setTitle("Favorite", for: .normal)
        btnRecent.setTitle("Recent", for: .normal)
        
        //set deFault layout
        isRecent = true
    }
    private func changeValue() {
            UIView.animate(withDuration: 0.2, animations: {[weak self] in
                self?.lineLeadingAnchor.constant = (self?.isRecent)! ? 70.0 : 0
                self?.layoutIfNeeded()
            })
            isRecent = !isRecent
            valueDidChange!(isRecent)
        }
    
    @IBAction func changeOption(_ sender: UIButton) {
        if (isRecent && sender.tag == 2) || (!isRecent && sender.tag == 1)  {
            changeValue()
        }
    }
    
}
