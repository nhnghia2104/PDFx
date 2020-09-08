//
//  HeaderDocumentView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/25/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class HeaderDocumentView: UICollectionReusableView {
    
    @IBOutlet weak var lblSortbyTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var lblSortByName: UILabel!
    @IBOutlet weak var lblSortByDate: UILabel!

    @IBOutlet weak var imgGridListLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imgGridList: UIImageView!
    @IBOutlet weak var lblGrid: UILabel!
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var leadingImageAnchor: NSLayoutConstraint!
    @IBOutlet weak var vLineUnder: UIView!

    @IBOutlet weak var btnIncrease: UIButton!
    var didChangeViewMode : ((Bool)->())?
    var didChangeSortMode : (([Bool])->())?
    // sortMode[0] ~ isSortByDate
    // sortMode[1] ~ orderedAscending != orderedDescending
    private var sortMode = [true,true]
    private var isViewAsList = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTheme()
    }
    func setupSortModeUI(sortMode : [Bool], isViewAsList : Bool) {
        self.sortMode = sortMode
        self.isViewAsList = isViewAsList
        imgGridList.image = isViewAsList ? UIImage(named: "ic_ListView") : UIImage(named: "ic_GridView")
        imgGridListLeadingAnchor.constant = isViewAsList ? 5 : 40
        lblList.alpha = isViewAsList ? 1 : 0
        lblGrid.alpha = isViewAsList ? 0 : 1
        

        lblSortbyTopAnchor.constant = (sortMode[0]) ? -(lblSortByName.frame.height) : 0
        
        btnIncrease.setImage(sortMode[1] ? UIImage(named: "ic_SortAscending")! : UIImage(named: "ic_SortDescending")!, for: .normal)

    }
    private func setupTheme() {
        // List Grid Mode
        lblList.font = UIFont.getFontOpenSans(style: .SemiBold, size: 13)
        lblGrid.font = UIFont.getFontOpenSans(style: .SemiBold, size: 13)
        lblGrid.textColor = CMSConfigConstants.shared.themeStyle.tintColor
        lblList.textColor = CMSConfigConstants.shared.themeStyle.tintColor
        imgGridList.image = isViewAsList ? UIImage(named: "ic_ListView") : UIImage(named: "ic_GridView")
        imgGridListLeadingAnchor.constant = isViewAsList ? 5 : 40
        lblList.alpha = isViewAsList ? 1 : 0
        lblGrid.alpha = isViewAsList ? 0 : 1
        imgGridList.tintColor = CMSConfigConstants.shared.themeStyle.tintColor
        
        // Sort Mode
        lblSortByDate.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        lblSortByName.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        lblSortByName.textColor = CMSConfigConstants.shared.themeStyle.tintGray
        lblSortByDate.textColor = CMSConfigConstants.shared.themeStyle.tintGray
        lblSortByName.text = "Sort by name"
        lblSortByDate.text = "Sort by date"
        
        btnIncrease.tintColor = CMSConfigConstants.shared.themeStyle.tintGray
        vLineUnder.backgroundColor = CMSConfigConstants.shared.themeStyle.borderColor


        btnIncrease.setImage(sortMode[1] ? UIImage(named: "ic_SortAscending") : UIImage(named: "ic_SortDescending"), for: .normal)
        
        
    }
    
    @IBAction func tapList() {
        isViewAsList = !isViewAsList
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            
            self?.imgGridListLeadingAnchor.constant = (self?.isViewAsList ?? false) ? 5 : 40
            self?.lblList.alpha = (self?.isViewAsList ?? false) ? 1 : 0
            self?.lblGrid.alpha = (self?.isViewAsList ?? false) ? 0 : 1
            self?.layoutIfNeeded()
        }) { [weak self] (complete) in
            if complete {
                UIView.animate(withDuration: 0.2) {
                    [weak self] in
                    self?.imgGridList.image = (self?.isViewAsList ?? false) ? UIImage(named: "ic_ListView") : UIImage(named: "ic_GridView")
                    self?.layoutIfNeeded()
                }
            }
        }
        didChangeViewMode!(isViewAsList)
    }

    @IBAction func tapSortBy() {
        sortMode[0].toggle()

        UIView.animate(withDuration: 0.2, animations: {
            [weak self] in
            self?.lblSortbyTopAnchor.constant = (self?.sortMode[0])! ? -(self?.lblSortByName.frame.height ?? 20) : 0
            self?.layoutIfNeeded()
        }) { [weak self](bool) in
            if bool {
                self?.didChangeSortMode!(self?.sortMode ?? [true,true])
            }
        }
        
    }
    @IBAction func tapIncrease() {
        sortMode[1] = !sortMode[1]
        btnIncrease.setImage(sortMode[1] ? UIImage(named: "ic_SortAscending")! : UIImage(named: "ic_SortDescending")!, for: .normal)
        didChangeSortMode!(sortMode)
    }
}
