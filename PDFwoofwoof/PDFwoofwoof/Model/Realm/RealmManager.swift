//
//  RealmManager.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/19/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Foundation
import RealmSwift
import PDFKit
class RealmManager {
    
    static let shared = RealmManager()
    private init() {}
    
    func saveRecentPDF(url : URL, completion:((Bool)->())? = nil) {
        existRecentPDF(url: url) { (result) in
            print("URLsave : \(url)")
            if result {
                self.updateRecentPDF(url: url) {
                    print("updated")
                    completion?(false)
                }
            }
            else {
                self.insertRecentPDF(url: url) {
                    print("inserted")
                    completion?(true)
                }
            }
            completion?(false)
        }
    }
    
    func getRecentPDF() -> [MyDocument]? {
        do {
            let realm = try Realm()
            
            let itemResult = realm
                .objects(RecentPDF.self)
            
            var arItem: [MyDocument] = []
            
            itemResult.forEach {
                let item = $0.getRecentPDF()
                if item.canGetPDF() {
                    arItem.append(item)
                }
                else {
                    $0.destroyObject()
                }
            }
            return arItem
        }catch let error as NSError {
            debugPrint("Realm error:",error)
            return nil
        }
    }
    func deleteRecent(url: String, completion:(()->())? = nil) {
        autoreleasepool {
            guard let realm = try? Realm() else {return}
            let itemResult = realm.objects(RecentPDF.self).filter("url == '\(url)'")
            try? realm.write {
                realm.delete(itemResult)
                completion?()
            }
        }
    }
    
    func updateRecentPDF(url: URL, completion:(()->())? = nil) {
        autoreleasepool {
            guard let realm = try? Realm() else {return}
            guard let theRecentPDF = realm
                .objects(RecentPDF.self)
                .filter("url == '\(url.path.description)'")
                .first else {
                    return
            }
            try? realm.write {
                theRecentPDF.dateModified = Date()
                completion?()
            }
        }
    }
    func insertRecentPDF(url: URL, completion:(()->())? = nil){
        let recent = RecentPDF()
        recent.setData(url: url, date: Date())
        autoreleasepool {
            guard let realm = try? Realm() else {return}
            
            try? realm.write {
                realm.add(recent)
                completion?()
            }
            
            
        }
    }
    
    func existRecentPDF(url: URL, completion: @escaping ((Bool)->())) {
        autoreleasepool {
            do {
                let realm = try Realm()
                let itemResult = realm
                    .objects(RecentPDF.self)
                    .filter("url == '\(url.path.description)'")
                itemResult.count > 0 ? completion(true) : completion(false)
            } catch let error as NSError {
                debugPrint("Realm error:",error)
            }
        }
    }
    
}
