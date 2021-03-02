//
//  UITableView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/25/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
extension UITableView {
    func setEmptyView(title : String, message : String, image : UIImage) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let subView = EmptyView.loadNib()
        subView.setData(title: title, message: message, image: image)
        
        emptyView.addSubview(subView)
        subView.frame = CGRect(x: 0, y: 0, width: emptyView.frame.width, height: emptyView.frame.height)
        emptyView.layoutIfNeeded()
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
