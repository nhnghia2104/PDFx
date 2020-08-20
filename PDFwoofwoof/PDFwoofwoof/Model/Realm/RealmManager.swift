//
//  RealmManager.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/19/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation
import RealmSwift
class RealmManager {
    
    static private func existPDFDocument(item: MyPDFDocument, completion: @escaping ((Bool)->())) {
        autoreleasepool {
            do {
                let realm = try Realm()
                let itemResult = realm
                    .objects(PDFObject.self)
                    .filter("pdfID == '\(item.pdfID.description)'")
                itemResult.count > 0 ? completion(true) : completion(false)
            } catch let error as NSError {
                debugPrint("Realm error:",error)
            }
        }
    }
    
    static public func savePdfObject(pdf : MyPDFDocument) {
        existPDFDocument(item: pdf) { (isExist)  in
            if !isExist {
                self.addMyPDFDocument(pdf: pdf)
            }
        }
    }
    
    static public func addMyPDFDocument(pdf : MyPDFDocument) {
        let pdfFile = PDFObject()
        pdfFile.setRealmValue(pdf : pdf)
        autoreleasepool {
            guard let realm = try? Realm() else {return}
            try? realm.write {
                realm.add(pdfFile)
            }
        }
    }
    
}
