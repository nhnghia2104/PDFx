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
    func clearAllRecent(completion : (()->())? = nil) {
        autoreleasepool {
            guard let realm = try? Realm() else {return}
            let items = realm.objects(RecentPDF.self)
            try? realm.write {
                realm.delete(items)
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
                theRecentPDF.dateAccess = Date()
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
                itemResult.isEmpty ? completion(false) : completion(true)
            } catch let error as NSError {
                debugPrint("Realm error:",error)
            }
        }
    }
    
    func existFavoritePDF(url : URL, completion : @escaping ((Bool)->())) {
        autoreleasepool {
            do {
                let realm = try Realm()
                let itemResult = realm
                    .objects(FavoritePDF.self)
                    .filter("url == '\(url.path.description)'")
                itemResult.isEmpty ? completion(false) : completion(true)
            } catch let error as NSError {
                debugPrint("Realm error:",error)
            }
        }
    }
    
    func deleteFavoritePDF(url: String, completion:(()->())? = nil) {
        autoreleasepool {
            guard let realm = try? Realm() else {return}
            let itemResult = realm.objects(FavoritePDF.self).filter("url == '\(url)'")
            if !itemResult.isEmpty {
                try? realm.write {
                    realm.delete(itemResult)
                    completion?()
                }
            }
        }
    }
    
    func insertFavoritePDF(url: URL, completion:(()->())? = nil){
        let recent = FavoritePDF()
        recent.setData(url: url)
        autoreleasepool {
            guard let realm = try? Realm() else {return}
            
            try? realm.write {
                realm.add(recent)
                completion?()
            }
            
            
        }
    }
    
    func saveFavoritePDF(url : URL, isFavorite : Bool) {
        
        if isFavorite {
            existFavoritePDF(url: url) { [weak self] (exist) in
                if exist {}
                else {
                    self?.insertFavoritePDF(url: url)
                }
            }
        }
        else {
            deleteFavoritePDF(url: url.path.description)
        }
        
    }
    
    func getFavoritePDF() -> [MyDocument]? {
        do {
            let realm = try Realm()
            
            let itemResult = realm
                .objects(FavoritePDF.self)
            
            var arItem: [MyDocument] = []
            
            itemResult.forEach {
                let item = $0.getFavorite()
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
    
    
    
}
