//
//  UICollectionView.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/28/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import SwipeCellKit
extension UICollectionView {
    func setEmptyView(title : String, message : String, image : UIImage) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let subView = EmptyView.loadNib()
        subView.setData(title: title, message: message, image: image)
        
        emptyView.addSubview(subView)
        subView.frame = CGRect(x: 0, y: 0, width: emptyView.frame.width, height: emptyView.frame.height)
        emptyView.layoutIfNeeded()
        
        self.backgroundView = emptyView
    }
    var swipeCells: [SwipeCollectionViewCell] {
        return visibleCells.compactMap({ $0 as? SwipeCollectionViewCell })
    }
    
    func hideSwipeCell() {
        swipeCells.forEach { $0.hideSwipe(animated: true) }
    }
    
    func setGestureEnabled(_ enabled: Bool) {
        gestureRecognizers?.forEach {
            guard $0 != panGestureRecognizer else { return }
            
            $0.isEnabled = enabled
        }
    }
}
