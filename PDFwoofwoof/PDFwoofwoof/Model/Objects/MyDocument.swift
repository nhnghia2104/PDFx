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
    private var document : Document!
    var isFavorite = false
    var url : URL?
    private var isFolder = false
    private var dateModified = Date()
    private var thumbnail : UIImage?
    private var name : String?
    private var dateCreated : Date?
    private var strSize : String?
    private var dateAcess : Date?
    init(url : URL) {
        self.url = url
        document = Document(fileURL: url)
            do {
                let resources = try self.document.fileURL.resourceValues(forKeys:[.fileSizeKey,.creationDateKey,.thumbnailDictionaryKey, .contentAccessDateKey])
                let fileSize = resources.fileSize ?? 0
                let strSize = Math.shared.convertSize(Double(fileSize))
                self.strSize = strSize
                self.dateCreated = resources.creationDate ?? Date()
                if let thumnailDict = resources.thumbnailDictionary {
                    if let img = (thumnailDict[URLThumbnailDictionaryItem(rawValue: "NSThumbnail1024x1024SizeKey")]) {
                        self.thumbnail = img
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        
        RealmManager.shared.existFavoritePDF(url: url) { [weak self] (isFavorite) in
                self?.isFavorite = isFavorite
        }

    }
    func setDateAccess(date : Date) {
        self.dateAcess = date
    }
    
    //  Getter
    func getDateCreated() -> Date {
        if dateCreated == nil {
            guard let pdf = PDFDocument(url: document.fileURL.absoluteURL) else {
                return Date()
            }
            let date = pdf.documentAttributes?[AnyHashable("ModDate")] as? Date
            dateCreated = date
        }
        return dateCreated!
    }
    
    func getURL() -> URL {
        return self.url!
    }
    
    func getAccessDate() -> Date {
        if dateAcess == nil {
            do {
                let resources = try self.document.fileURL.resourceValues(forKeys:[.contentAccessDateKey])
                self.dateAcess = resources.contentAccessDate ?? Date()
            } catch {
                print("Error: \(error)")
            }
        }
        return dateAcess!
    }
    
    func getStrAccessDate() -> String {
        if dateAcess == nil {
            self.dateAcess = Date()
        }
        return (dateAcess?.timeAgoDisplay())!
    }
    
    func getFileName() -> String {
        if name == nil {
            var fileName = document.fileURL.lastPathComponent
            if fileName.components(separatedBy: ".").last == "pdf" && fileName.components(separatedBy: ".").count > 1 {
                fileName.removeLast(4)
            }
            name = fileName
        }
        return name!
    }

    func getStrSize() -> String {
        if strSize == nil {
            do {
                let resources = try document.fileURL.resourceValues(forKeys:[.fileSizeKey])
                let fileSize = resources.fileSize ?? 0
                let strSize = Math.shared.convertSize(Double(fileSize))
                self.strSize = strSize
            } catch {
                strSize = ""
                print("Error: \(error)")
            }
        }
        return strSize!
    }
    
    func getStrDateCreated() -> String {
        if dateCreated == nil {
            guard let pdf = PDFDocument(url: document.fileURL.absoluteURL) else {
                return ""
            }
            let dateModified = pdf.documentAttributes?[AnyHashable("ModDate")] as? Date
            dateCreated = dateModified == nil ? Date() : dateModified
        }
        return (dateCreated?.toString(format: "MMM dd, yyyy"))!
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
        return (dateCreated?.toString(format: "MMM dd, yyyy  hh:mm a"))! + "  •  "
    }
    
    func getPDFData() -> Document {
        return document
    }
    
    func getThumbnail() -> UIImage {
        if self.thumbnail == nil {
            guard let pdf = PDFDocument(url: document.fileURL.absoluteURL) else { return UIImage() }
            guard let page = pdf.page(at: 0) else { return UIImage() }
            self.thumbnail = page.thumbnail(of: isiPadUI ? CGSize(width: 1024, height: 1024) : CGSize(width: 90, height: 120), for: .cropBox)
        }
        return self.thumbnail!
    }
    
    func canGetPDF() -> Bool {
        if PDFDocument(url: document.fileURL.absoluteURL) == nil { return false }
        return true
    }
    func getURLPath() -> String {
        return document.fileURL.path
    }
}

