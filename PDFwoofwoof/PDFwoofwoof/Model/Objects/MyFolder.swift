//
//  MyFolder.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/22/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation
class MyFolder {
    var url : URL
    private var dateCreated : Date?
    init(url : URL) {
        self.url = url
    }
    func getDateCreated() -> Date {
        if dateCreated == nil {
            let document = Document(fileURL: url)
            dateCreated = document.fileModificationDate ?? Date()
        }
        return dateCreated!
    }
    func getName() -> String {
        return url.lastPathComponent
    }
}
