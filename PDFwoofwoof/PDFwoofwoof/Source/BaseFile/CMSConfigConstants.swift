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
    var tintColor : UIColor = UIColor(hex: "393e46")
    var titleColor : UIColor = UIColor(hex: "222831")
    var selectColor : UIColor = UIColor(hex: "3282b8")
    var borderColor : UIColor = UIColor(hex: "ececec", alpha: 1)
}
