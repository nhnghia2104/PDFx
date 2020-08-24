//
//  FileManager.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/20/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation
extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
    static func checkFileExists(url:URL) -> Bool {
        if self.default.fileExists(atPath: url.path) {
            return true
        } else {
            return false
        }
    }
//    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    if let urlArray = try? FileManager.default.contentsOfDirectory(at: directory,
//                                                                   includingPropertiesForKeys: [.contentModificationDateKey],
//                                                                   options:.skipsHiddenFiles) {
//
//        return urlArray.map { url in
//                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
//            }
//            .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
//            .map { $0.0 } // extract file names
//
//    } else {
//        return nil
//    }
}
