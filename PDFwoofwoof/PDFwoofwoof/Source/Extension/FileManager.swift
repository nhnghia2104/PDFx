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
}
