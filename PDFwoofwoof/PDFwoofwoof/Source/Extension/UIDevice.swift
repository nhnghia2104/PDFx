//
//  UIDevice.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/3/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
extension UIDevice {
    func IS_169_RATIO() -> Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
