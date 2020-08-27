//
//  HeaderDocumentView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/25/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class HeaderDocumentView: UICollectionReusableView {
    
    @IBOutlet weak var vLineUnder: UIView!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnSortby: UIButton!
    @IBOutlet weak var btnIncrease: UIButton!
    var didChangeViewMode : ((Bool)->())?
    var didChangeSortMode : (([Bool])->())?
    var didTapSelectMode : (()->())?
    
    // sortMode[0] ~ isSortByDate
    // sortMode[1] ~ orderedAscending != orderedDescending
    private var sortMode = [true,true] {
        didSet {
             btnSortby.setTitle(sortMode[0] ? "Sort by date" : "Sort by name", for: .normal)
            btnIncrease.setImage(sortMode[1] ? UIImage(named: "ic_SortAscending")! : UIImage(named: "ic_SortDescending")!, for: .normal)
        }
    }
    private var isViewAsList = true {
        didSet {
            btnList.setImage(isViewAsList ? UIImage(named: "ic_ListView") : UIImage(named: "ic_GridView"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTheme()
    }
    func setupSortModeUI(sortMode : [Bool], isViewAsList : Bool) {
        self.sortMode = sortMode
        self.isViewAsList = isViewAsList
    }
    private func setupTheme() {
       
        btnList.tintColor = CMSConfigConstants.themeStyle.tintColor
       
        btnSortby.tintColor = CMSConfigConstants.themeStyle.tintColor
        btnIncrease.tintColor = CMSConfigConstants.themeStyle.tintColor
        vLineUnder.backgroundColor = CMSConfigConstants.themeStyle.borderColor
        btnSortby.titleLabel?.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        btnSortby.setTitle(sortMode[0] ? "Sort by date" : "Sort by name", for: .normal)
        btnIncrease.setImage(sortMode[1] ? UIImage(named: "ic_SortAscending") : UIImage(named: "ic_SortDescending"), for: .normal)
        btnList.backgroundColor = UIColor(hex: "ececec", alpha: 0.5)
    }
    
    @IBAction func tapList() {
        isViewAsList = !isViewAsList
        didChangeViewMode!(isViewAsList)
    }

    @IBAction func tapSortBy() {
        sortMode[0] = !sortMode[0]
        didChangeSortMode!(sortMode)
    }
    @IBAction func tapIncrease() {
        sortMode[1] = !sortMode[1]
        didChangeSortMode!(sortMode)
    }
    @IBAction func tapSelect() {
        didTapSelectMode!()
    }
}
