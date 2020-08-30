//
//  Notification.swift
//  PDFwoofwoof
//
//  Created by Minh on 8/28/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import PDFKit

class Notice {
    var message: String = ""
    var timeSent: String = ""
    var img: UIImage?
    
    init(message: String, timeSent: String, img: UIImage) {
        self.message = message
        self.timeSent = timeSent
        self.img = img
    }
}
