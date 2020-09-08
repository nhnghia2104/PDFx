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
    case plit
    case scan
    case createPDF
    case createFolder
    case browse
    case none
}
class Tool {
    var type : TypeTool
    var name : String = ""
    var icon : UIImage?
    init(name : String, icon : UIImage?, type : TypeTool = .none) {
        if icon == nil {
            self.icon = UIImage(named: "ic_Home")
        }
        else {
            self.icon = icon
        }
        self.name = name
        self.type = type
    }
}
