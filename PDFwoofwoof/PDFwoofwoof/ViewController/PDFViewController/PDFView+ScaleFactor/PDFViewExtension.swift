//
//  PDFViewExtension.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/24/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import PDFKit

// scaleFactor
public struct HGPDFScaleFactor {
    // store factor for single mode
    public var portrait: CGFloat
    public var landscape: CGFloat
    // devide by 2 for two up mode
    
    public init(portrait: CGFloat, landscape: CGFloat) {
        self.portrait = portrait
        self.landscape = landscape
    }
}

extension PDFView {
    public var scrollView: UIScrollView? {
        for view in self.subviews {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
        }
        return nil
    }
    
    struct Holder {
        // different form pdfView.scaleFactorForSizeToFit, the scaleFactorForSizeToFit use superArea not safeArea
        static var hgScaleFactorForSizeToFit: HGPDFScaleFactor?
        static var hgScaleFactorVertical: HGPDFScaleFactor = HGPDFScaleFactor(portrait: 0.25, landscape: 0.25)
        static var hgScaleFactorHorizontal: HGPDFScaleFactor = HGPDFScaleFactor(portrait: 0.25, landscape: 0.25)
        static var isZoomedIn: Bool = false
    }
}
