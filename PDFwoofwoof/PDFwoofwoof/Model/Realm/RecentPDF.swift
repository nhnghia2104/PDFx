//
//  RecentPDF.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/23/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import RealmSwift
import Realm
import UIKit
import PDFKit

class RecentPDF : Object {
    @objc dynamic var url : String = ""
    @objc dynamic var dateModified = Date()
    
    func setData(url : URL, date : Date) {
        self.url = url.path.description
        self.dateModified = date
    }
    func getRecentPDF() -> MyDocument {
        let theRecent = MyDocument(url: URL(fileURLWithPath: self.url))
        theRecent.setModified(date: self.dateModified)
        return theRecent
    }
    func destroyObject() {
        RealmManager.shared.deleteRecent(url: self.url)
    }
}
