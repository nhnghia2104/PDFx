//
//  FavoritePDF.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/23/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import RealmSwift
import Realm
import UIKit

class FavoritePDF : Object {
    @objc dynamic var url : String = ""
    @objc dynamic var dateModified = Date()
}
