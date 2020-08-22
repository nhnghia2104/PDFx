//
//  Date.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/22/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//
import UIKit
extension Date {
    func currentDateTime() -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = .current
        dateFormater.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let str = dateFormater.string(from: Date())
        
        return str
    }
    func dateTimeFormat() -> String {
        let description = self.description.components(separatedBy: " ")
        return description[0] + " " + description[1]
    }
    func getStrDate() -> String {
        let description = self.description.components(separatedBy: " ")
        return description[0]
    }
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let result = formatter.string(from: self)
        return result
    }
}
