//
//  PDFViewController.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/23/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//


import UIKit
import PDFKit
import CloudKit

class PDFViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    @IBOutlet weak var pdfView: PDFView!
    
    var document: Document?

    
    deinit {
        print("deinit PDFViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        
        if (pdfView.document != nil) { return }
        
        // Access the document
        document?.open(completionHandler: { [weak self] (success) in
            if success {
                
                guard let pdfURL: URL = (self?.document?.fileURL) else { return }
                guard let document = PDFDocument(url: pdfURL) else { return }
                
                self?.pdfView.document = document
                self?.pdfView.minScaleFactor = self?.pdfView.scaleFactorForSizeToFit as! CGFloat
            } else {

            }
        })
    }
    
    override func viewDidLoad() {

        pdfView.autoScales = true
        pdfView.displaysPageBreaks = true
        pdfView.displayBox = .cropBox
        
        
        pdfView.scrollView?.scrollsToTop = false
        pdfView.scrollView?.contentInsetAdjustmentBehavior = .scrollableAxes
        
    }
    //MARK: - START NGHIAXXXXX

    func config(with doc : Document) {
        self.document = doc
    }
    
    @IBAction func tapDissmis() {
        self.dismiss(animated: true, completion: nil)
    }
}
    //MARK: - END NGHIAXXXXX
