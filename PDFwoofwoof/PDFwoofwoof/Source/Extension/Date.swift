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
    func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "Just now" //"\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
//        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
//        return "\(diff) weeks ago"
        return self.toString(format: "MMM dd, yyyy")
    }
}
