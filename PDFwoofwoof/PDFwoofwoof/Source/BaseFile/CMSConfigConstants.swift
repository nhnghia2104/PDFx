//
//  CMSConfigConstants.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/15/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

struct CMSConfigConstants {
//    static let shared = CMSConfigConstants()
//    private init() { }
    static var themeStyle = ThemeStyle()
}
struct ThemeStyle {
    
    // https://coolors.co/f8f9fa-e9ecef-dee2e6-ced4da-adb5bd-6c757d-495057-343a40-212529
    // https://coolors.co/03045e-023e8a-0077b6-0096c7-00b4d8-48cae4-90e0ef-ade8f4-caf0f8
    
    var tintColor : UIColor = UIColor(hex: "393e46")
    var titleColor : UIColor = UIColor(hex: "222831")
    var title2 : UIColor = UIColor(hex: "393b44")
    var selectColor : UIColor = UIColor(hex: "3282b8")
    var borderColor : UIColor = UIColor(hex: "ececec", alpha: 1)
    var backgroundBlue : UIColor = UIColor(hex: "ececec", alpha: 1)
    var backgroundGray : UIColor = UIColor(hex: "f8f9fa", alpha: 1)
    var tintBlue : UIColor = UIColor(hex: "0096c7", alpha : 1)
    var tintGray : UIColor = UIColor(hex: "6c757d", alpha: 1)
}
