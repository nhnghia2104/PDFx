//
//  ShadowView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/3/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    //Shadow
    @IBInspectable var shadowColor: UIColor = UIColor.darkGray {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 1) {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 5.0 {
        didSet {
            self.updateView()
        }
    }

    //Apply params
    func updateView() {
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
    }
}
