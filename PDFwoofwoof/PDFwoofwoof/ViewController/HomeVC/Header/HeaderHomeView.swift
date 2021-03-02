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
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnRecent: UIButton!
    @IBOutlet weak var lineLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var vLine: UIView!
    var valueDidChange : ((Bool)->())?
    var didTapClear : (()->())?
    var isRecent = true {
        didSet {
            btnRecent.titleLabel?.font = isRecent ? UIFont.getFontOpenSans(style: .SemiBold, size: 14) : UIFont.getFontOpenSans(style: .Regular, size: 14)
            btnFavorite.titleLabel?.font = isRecent ? UIFont.getFontOpenSans(style: .Regular, size: 14) : UIFont.getFontOpenSans(style: .SemiBold, size: 14)
            btnRecent.alpha = isRecent ? 1.0 : 0.7
            btnFavorite.alpha = isRecent ? 0.7 : 1.0
            btnClear.isHidden = !isRecent
            lineLeadingAnchor.constant = isRecent ? 0 : 70
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTheme()
    }
    private func setupTheme() {
        vLineUnder.backgroundColor = CMSConfigConstants.shared.themeStyle.titleColor
        vLine.backgroundColor = CMSConfigConstants.shared.themeStyle.borderColor
        btnRecent.setTitleColor(CMSConfigConstants.shared.themeStyle.titleColor, for: .normal)
        btnFavorite.setTitleColor(CMSConfigConstants.shared.themeStyle.titleColor, for: .normal)
        btnClear.setTitleColor(CMSConfigConstants.shared.themeStyle.titleColor, for: .normal)
        btnClear.titleLabel?.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        btnFavorite.setTitle("Favorite", for: .normal)
        btnRecent.setTitle("Recent", for: .normal)
        btnClear.setTitle("Clear", for: .normal)
        //set deFault layout
        isRecent = true
    }
    private func changeValue() {
            UIView.animate(withDuration: 0.2, animations: {[weak self] in
                self?.isRecent.toggle()
                self?.layoutIfNeeded()
            })
            valueDidChange!(isRecent)
        }
    
    @IBAction func changeOption(_ sender: UIButton) {
        if (isRecent && sender.tag == 2) || (!isRecent && sender.tag == 1)  {
            changeValue()
        }
    }
    @IBAction func tapClear() {
        didTapClear!()
    }
    
}
