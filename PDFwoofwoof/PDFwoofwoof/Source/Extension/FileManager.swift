//
//  FileManager.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/20/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//
import PDFKit
import Foundation
extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
    func checkFileExists(url:URL) -> Bool {
        if FileManager.default.fileExists(atPath: url.path) {
            return true
        } else {
            return false
        }
    }
    func checkPathExist(path : String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            return true
        } else {
            return false
        }
    }
    func getFileURLs(from url: URL) -> [URL]? {
        let fileURLs = try? contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return fileURLs
    }

    func saveFile(from url : URL, complete: @escaping ((Bool,URL)->())) {
        guard let pdf = PDFDocument(url: url) else {
            complete(false,url)
            return
        }
        // Step 1:
        // Create a URL and make sure it can be saved
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var name = url.deletingPathExtension().lastPathComponent
        var newPath = documentDirectory.appendingPathComponent(name + ".pdf")
        if FileManager.default.checkFileExists(url: newPath) == true {

            
            var element : Int = 1
            newPath = newPath.deletingLastPathComponent()
            newPath = newPath.appendingPathComponent("\(name)(\(element)).pdf")
            //newPath = path//(path: "\(name)(\(element)).pdf")
            while FileManager.default.checkFileExists(url: newPath) == true {
                element += 1
                newPath = newPath.deletingLastPathComponent()
                newPath = newPath.appendingPathComponent("\(name)(\(element)).pdf")
            }
            name = name + "(\(element))"
        }
        // Step 2.
        // Save file to url created
//        let needTo = url.startAccessingSecurityScopedResource()
        do {
            let data = try Data(contentsOf: url)
            try data.write(to: documentDirectory.appendingPathComponent(name + ".pdf"))
        }
        catch {
            
        }
//        if needTo {
//            url.stopAccessingSecurityScopedResource()
//        }
        complete(true,documentDirectory.appendingPathComponent(name + ".pdf"))
        
        
    }
}
