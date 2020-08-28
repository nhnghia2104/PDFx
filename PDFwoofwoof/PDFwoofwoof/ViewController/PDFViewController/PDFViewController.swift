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
    var document : Document?
    
    //MARK: - override function
    deinit {
        print("denited PDFView")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPDFView()
        setupNaviBar()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    // MARK: - public function
    func config(with file : Document) {
        self.document = file
        accessDocument()
    }
    
    //MARK: - setup function
    private func accessDocument() {
        document?.open(completionHandler: { [weak self](success) in
            if success {
                // Display the content of the document, e.g.:
                self?.navigationItem.title = self?.document?.localizedName
                guard let pdfURL: URL = (self?.document?.fileURL) else { return }
                guard let document = PDFDocument(url: pdfURL) else { return }
                
//                self.isEncrypted = document.isEncrypted
                
                self?.pdfView.document = document
                
//                self.moveToLastViewedPage()
//                self.getScaleFactorForSizeToFitAndOffset()
//                self.pdfView.setMinScaleFactorForSizeToFit()
//                self.pdfView.setScaleFactorForUser()
                
//                self.setPDFThumbnailView()
                
//                if let documentEntity = self.currentEntity {
//                    self.isHorizontalScroll = documentEntity.isHorizontalScroll
//                    self.isRightToLeft = documentEntity.isRightToLeft
//                    self.updateScrollDirection()
//                }
//                self.moveToLastViewedOffset()
//
//                self.checkForNewerRecords()
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    private func setupPDFView() {
        pdfView.autoScales = true
        pdfView.displaysPageBreaks = true
        pdfView.displayBox = .cropBox

        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical

    }
    private func setupNaviBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CMSConfigConstants.themeStyle.titleColor,
        NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .SemiBold, size: 15)]
        setupBaseNavigation()
        addLeftBarButtonWithImage(img: UIImage(named: "navi_Back")!, action: #selector(tapBack))
    }
    
    @objc func tapBack() {
        dismiss(animated: true) {
            //do something
        }
    }
    
}
