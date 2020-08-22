//
//  MyPDFDocument.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/17/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit

class MyPDFDocument {

    var data : PDFDocument?
    var strSize : String = ""
    var strDateModifed : String = ""
    init(url : URL) {
        self.config(with : url)
    }
    private func config(with url : URL) {
        guard let pdf = PDFDocument(url:url) else {
            return
        }
        self.data = pdf
        
        
        if !pdf.isLocked {
            if pdf.documentAttributes != nil {
                var dateModified = pdf.documentAttributes?[AnyHashable("ModDate")] as? Date
                dateModified = dateModified == nil ? Date() : dateModified
                //                pdf.documentAttributes?.updateValue(dateModified ?? Date(), forKey: [AnyHashable("ModDate")])
                
                let strDateFormat1 = dateModified?.toString(format: "yyyy-MM-dd hh:mm:ss a")
                let strDateFormat2 = dateModified?.toString(format: "MMM dd,yyyy")
                let dateComponents = strDateFormat1?.components(separatedBy: " ") // •
                self.strDateModifed =  strDateFormat2 ?? "" + " "
                if strDateFormat1?.count == 3 {
                    let times = dateComponents?[1].components(separatedBy: ":")
                    if times?.count ?? 0 > 2 {
                        self.strDateModifed = self.strDateModifed + times![0] + ":" + times![1] + " " + dateComponents![2]
                    }
                }
            }
            
            do {
                let resources = try pdf.documentURL?.resourceValues(forKeys:[.fileSizeKey])
                
                let fileSize = resources?.fileSize!
                let strSize = Math.shared.convertSize(Double(fileSize ?? 0))
                self.strSize = strSize
            } catch {
                print("Error: \(error)")
            }
            
        } // else mean file pdf was password protected
        
    }
}
