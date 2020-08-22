//
//  Math.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/22/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
struct Math {
    static let shared  = Math()
    
    func roundToDeCimal(_ value: Double, toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    func convertSize(_ value: Double) -> String {
        var fileSize = value
        var type = 0 // 1 : KB
                    // 2: MB
                    // 3 : GB
        while fileSize > 1024 && type < 3 { // <3  : maxium is GB
            type += 1
            fileSize /= 1024
        }
        switch type {
        case 1:
            return "\(roundToDeCimal(fileSize, toDecimalPlaces: 1)) KB"
        case 2:
            return "\(roundToDeCimal(fileSize, toDecimalPlaces: 1)) MB"
        case 3:
            return "\(roundToDeCimal(fileSize, toDecimalPlaces: 1)) GB"
        default:
            return ""
        }
    }
}
