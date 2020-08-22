//
//  PDFViewController.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/23/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit
class PDFViewController : UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    var pdfFile : PDFDocument!
    
    //MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPDFView()
        setupNaviBar()
     
    }
    // MARK: - public function
    func config(with file : MyPDFDocument) {
        self.pdfFile = file.data
    }
    
    //MARK: - setup function
    private func setupPDFView() {
        pdfView.document = pdfFile
        pdfView.autoScales = true
        if !isiPadUI {
            pdfView.minScaleFactor = pdfView.scaleFactor
        }
        //        pdfView.maxScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.displayMode = .singlePageContinuous
        if #available(iOS 12.0, *) {
            pdfView.pageShadowsEnabled = true
        } else {
            // Fallback on earlier versions
        }
        //        pdfView.displayBox = .artBox
        pdfView.displayDirection = .vertical
        //        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
    }
    private func setupNaviBar() {
        setupBaseNavigation()
    }
    
}
