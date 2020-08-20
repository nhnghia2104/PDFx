//
//  UIFont.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/13/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
enum fontStyle: Int {
    
    case SemiBold = 0
    case Light
    case Italic
    case LightItalic
    case Regular
    case Bold
    case SemiBoldItalic
    case BoldItalic
    
}
extension UIFont {
    class func getFontBold(size: CGFloat) -> UIFont {
        
        return UIFont(name: "OpenSans-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func getFontRegular(size : CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func getFontLight(size : CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size) ?? UIFont.italicSystemFont(ofSize: size)
    }
    
    class func getFontOpenSans(style : fontStyle, size : CGFloat) -> UIFont {
        switch style {
        case .SemiBold:
            return UIFont(name: "OpenSans-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
        case .Light:
            return UIFont(name: "OpenSans-Light", size: size) ?? UIFont.systemFont(ofSize: size)
        case .Italic:
            return UIFont(name: "OpenSans-Italic", size: size) ?? UIFont.systemFont(ofSize: size)
        case .LightItalic:
            return UIFont(name: "OpenSans-LightItalic", size: size) ?? UIFont.systemFont(ofSize: size)
        case .Regular:
            return UIFont(name: "OpenSans-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        case .Bold:
            return UIFont(name: "OpenSans-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        case .SemiBoldItalic:
            return UIFont(name: "OpenSans-SemiBoldItalic", size: size) ?? UIFont.systemFont(ofSize: size)
        case .BoldItalic:
            return UIFont(name: "OpenSans-BoldItalic", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}
