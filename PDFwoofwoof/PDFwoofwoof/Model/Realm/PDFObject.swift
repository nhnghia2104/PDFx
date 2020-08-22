//
//  PDFObject.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/17/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import RealmSwift
import UIKit
import Realm
class PDFObject : Object {
    @objc dynamic var pdfID = ""
    @objc dynamic var pdfUrl = ""
    @objc dynamic var pdfDateModified : Date?
    @objc dynamic var pdfIsFavorite = false
    @objc dynamic var pdfIsRecent = false
    
    func setRealmValue(pdf : MyPDFDocument) {

    }
}
