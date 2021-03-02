//
//  UIImage+SFSymbol.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/6/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//


import UIKit

extension UIImage {
    
    /// Creates an image object containing a system symbol image appropriate for the specified traits if supported (iOS13 and above). Otherwise an image object using the named image asset that is compatible with the specified trait collection will be created.
    convenience init?(systemName: String, named: String, in bundle: Bundle? = nil, compatibleWith traitCollection: UITraitCollection? = nil) {
        if #available(iOS 13.0, *) {
            self.init(systemName: systemName, compatibleWith: traitCollection)
        } else {
            self.init(named: named, in: bundle, compatibleWith: traitCollection)
        }
    }
}
