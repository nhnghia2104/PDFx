//
//  UIViewController.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/12/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setSlideMenuVCNaviBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
//        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
    }
    
    func removeSlideMenuGesture() {
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func removeSlideMenuBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
    
    func removeNaviBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func addLeftBarButtonWithTittle(title : String, action : Selector?) {
//        let leftButton : UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        btn.setTitleColor(CMSConfigConstants.shared.themeStyle.titleColor, for: .normal)
        btn.addTarget(self, action: action!, for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn), animated: false)
    }
    
    func addRightBarButtonWithTittle(title : String, action : Selector?) {
//        let rightButton : UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        btn.setTitleColor(CMSConfigConstants.shared.themeStyle.titleColor, for: .normal)
        btn.addTarget(self, action: action!, for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn), animated: false)
    }
    
    func addLeftBarButtonWithImage(img : UIImage, action : Selector?) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: action)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
//        self.navigationItem.leftBarButtonItem = leftButton
    }
    func addRightBarButtonWithImage(img : UIImage, action : Selector?) {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: action)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
//        self.navigationItem.rightBarButtonItem = rightButton
    }
    func setupBaseNavigation() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .SemiBold, size: 14)], for: .normal)
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: CMSConfigConstants.shared.themeStyle.titleColor,
             NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .Bold, size: 28)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CMSConfigConstants.shared.themeStyle.titleColor,
                                                                        NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .SemiBold, size: 15)]
        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
//        self.navigationController?.navigationBar.layer.shadowRadius = 5.0
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
//        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
}
