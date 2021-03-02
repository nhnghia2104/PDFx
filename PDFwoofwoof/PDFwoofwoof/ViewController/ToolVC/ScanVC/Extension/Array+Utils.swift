//
//  Array+Utils.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/6/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import Vision
import Foundation

extension Array where Element == Quadrilateral {
    
    /// Finds the biggest rectangle within an array of `Quadrilateral` objects.
    func biggest() -> Quadrilateral? {
        let biggestRectangle = self.max(by: { (rect1, rect2) -> Bool in
            return rect1.perimeter < rect2.perimeter
        })
        
        return biggestRectangle
    }
    
}
