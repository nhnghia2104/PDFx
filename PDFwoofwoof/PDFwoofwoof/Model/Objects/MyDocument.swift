//
//  MyDocument.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/17/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit

class MyDocument {
    var document : Document!
    var isFavorite = false
    var isFolder = false
    var dateModified = Date()
    private var dateCreated : Date?
    init(url : URL) {
        document = Document(fileURL: url)
    }
    func getFileName() -> String {
        var fileName = document.fileURL.lastPathComponent
        if fileName.components(separatedBy: ".").last == "pdf" && fileName.components(separatedBy: ".").count > 1 {
            fileName.removeLast(4)
        }
        return fileName
    }

    func getStrSize() -> String {
        do {
            let resources = try document.fileURL.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize ?? 0
            let strSize = Math.shared.convertSize(Double(fileSize))
            return strSize
        } catch {
            print("Error: \(error)")
        }
        return ""
    }
    
    func getStrDateCreated() -> String {
        if dateCreated == nil {
            guard let pdf = PDFDocument(url: document.fileURL.absoluteURL) else {
                return ""
            }
            let dateModified = pdf.documentAttributes?[AnyHashable("ModDate")] as? Date
            dateCreated = dateModified == nil ? Date() : dateModified
        }
        return (dateCreated?.toString(format: "dd-MM-yyyy"))!
    }
    
    func getStrTimeCreated() -> String {
        if dateCreated == nil {
            guard let pdf = PDFDocument(url: document.fileURL.absoluteURL) else {
                return ""
            }
            let dateModified = pdf.documentAttributes?[AnyHashable("ModDate")] as? Date
            dateCreated = dateModified == nil ? Date() : dateModified
        }
        return (dateCreated?.toString(format: "hh:mm a"))!
    }
    
    func getStrDateTimeCreated() -> String {
        if dateCreated == nil {
            guard let pdf = PDFDocument(url: document.fileURL.absoluteURL) else {
                return ""
            }
            let dateModified = pdf.documentAttributes?[AnyHashable("ModDate")] as? Date
            dateCreated = dateModified == nil ? Date() : dateModified
        }
        return (dateCreated?.toString(format: "dd-MM-yyyy  hh:mm a"))! + "  •  "
    }
    
    func getPDFData() -> Document {
        return document
    }
    
    func getThumbnail() -> UIImage {
        guard let pdf = PDFDocument(url: document.fileURL.absoluteURL) else { return UIImage() }
        guard let page = pdf.page(at: 0) else { return UIImage() }
        return page.thumbnail(of: CGSize(width: 300, height: 400), for: .cropBox)
    }
    
    func canGetPDF() -> Bool {
        if PDFDocument(url: document.fileURL.absoluteURL) == nil { return false }
        return true
    }
}

