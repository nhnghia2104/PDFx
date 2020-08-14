//
//  Tool.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/13/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation
import PDFKit
enum ToolType {
    
}
class Tool {
    var name : String = ""
    var icon : UIImage?
    var tintColor : UIColor?
    var backgroundColor : UIColor?
    init(name : String, icon : UIImage, tintColor : UIColor, background : UIColor) {
        self.name = name
        self.icon = icon
        self.tintColor = tintColor
        self.backgroundColor = background
    }
}
