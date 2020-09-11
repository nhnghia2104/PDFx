//
//  Tool.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/13/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation
import PDFKit

enum TypeTool {
    case merge
    case split
    case scan
    case createPDF
    case createFolder
    case browse
    case none
    case setPassword
    case extract
    case organize
    case sign
}
class Tool {
    var type : TypeTool
    var name : String = ""
    var icon : UIImage?
    var background : UIColor?
    init(name : String, icon : UIImage?, type : TypeTool = .none, color : UIColor? = nil) {
        self.background = color == nil ? .white : color
        self.icon = icon == nil ? UIImage(named: "ic_Home") : icon
        self.name = name
        self.type = type
    }
}
