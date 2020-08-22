//
//  DocumentsVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/20/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit

class DocumentsVC: UIViewController {
    
    @IBOutlet weak var leadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var imgSortby: UIImageView!
    @IBOutlet weak var lblSortby: UILabel!
    @IBOutlet weak var clvDocument: UICollectionView!
    
    private var listFolder = [MyFolder]()
    private var listDocument = [MyPDFDocument]()
    var direct = FileManager.default
    
    private var isViewAsList = true {
        didSet {
            changeListGridIcon()
        }
    }
    // MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        register()
        setupTheme()
        setupCollectionView()
        if UserDefaults.standard.object(forKey: "isViewAsList") == nil {
            UserDefaults.standard.setValue(true, forKey: "isViewAsList")
        }
        if let bool = UserDefaults.standard.object(forKey: "isViewAsList") as? Bool {
            isViewAsList = bool
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFileFromDevice()
    }

    // MARK: - setup functions
    private func setupNavigation() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: CMSConfigConstants.themeStyle.black,
                                                                        NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .SemiBold, size: 15)]
        self.navigationItem.title = "Documents"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
        self.setSlideMenuVCNaviBarItem()
        self.addRightBarButtonWithImage(img: UIImage(named: "ic_more_2")!, action: #selector(openMore))
        setupBaseNavigation()
    }
    private func setupCollectionView() {
        self.clvDocument.decelerationRate = UIScrollView.DecelerationRate.normal
        clvDocument.contentInset.bottom = clvDocument.contentInset.bottom + 40.0
        
        let layoutDrag: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutDrag.scrollDirection = .vertical
        clvDocument.collectionViewLayout = layoutDrag
    }
    private func register() {
        clvDocument.register(UINib(nibName: "ListDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListDocCollectionViewCell")
        clvDocument.register(UINib(nibName: "GridDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridDocCollectionViewCell")
    }
    private func setupTheme() {
        btnGrid.tintColor = CMSConfigConstants.themeStyle.gray1
        btnList.tintColor = CMSConfigConstants.themeStyle.gray1
        btnSelect.tintColor = CMSConfigConstants.themeStyle.gray1
        
        lblSortby.font = UIFont.getFontOpenSans(style: .Regular, size: 13)
        lblSortby.tintColor = CMSConfigConstants.themeStyle.gray1
        imgSortby.tintColor = CMSConfigConstants.themeStyle.gray1
        
    }
    private func loadFileFromDevice() {
        let fileManager = FileManager.default
        if let documentURL = fileManager.urls(for: .documentDirectory, skipsHiddenFiles: true) {
            
            loadPDFDocument(urls: documentURL.filter{ $0.pathExtension == "pdf" })
            
            loadFolder(urls: documentURL.filter{ $0.pathExtension == "" })
        }
    }
    private func loadPDFDocument(urls : [URL]) {
        listDocument.removeAll()
        for url in urls {
            if PDFDocument(url: url) != nil {
                let child = MyPDFDocument(url: url)
                listDocument.append(child)
            }
        }
    }
    private func loadFolder(urls : [URL]) {
        listFolder.removeAll()
        for url in urls {
            let child = MyFolder(url: url)
            listFolder.append(child)
        }
    }
    // MARK: - IBAction
    @IBAction func tapListMode() {
        UserDefaults.standard.setValue(true, forKey: "isViewAsList")
        isViewAsList = true
    }
    @IBAction func tapGridMode() {
        UserDefaults.standard.setValue(false, forKey: "isViewAsList")
        isViewAsList = false
    }
    //MARK: - objc funtion
    @objc func openMore() {
        
    }
    //MARK: - Action function
    private func changeListGridIcon() {
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.leadingAnchor.constant = (self?.isViewAsList)! ? 30.0 : 0
            self?.view.layoutIfNeeded()
        })
        clvDocument.reloadData()
    }
}

extension DocumentsVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDocument.count + listFolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isViewAsList {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListDocCollectionViewCell", for: indexPath) as? ListDocCollectionViewCell else {return UICollectionViewCell()}
            if indexPath.item < listFolder.count {
                cell.setFolderData(folder: listFolder[indexPath.item])
            }
            else {
                cell.setDocuemtData(pdf: listDocument[indexPath.item - listFolder.count])
            }
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridDocCollectionViewCell", for: indexPath) as? GridDocCollectionViewCell else {return UICollectionViewCell()}
            if indexPath.item < listFolder.count {
                cell.setFolderData(folder: listFolder[indexPath.item])
            }
            else {
                cell.setDocuemtData(pdf: listDocument[indexPath.item - listFolder.count])
            }
            return cell
        }
    }
    
    
    
    
}

extension DocumentsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isViewAsList {
            return CGSize(width: clvDocument.frame.width, height: 75)
        }
        else {
            let width = ( clvDocument.frame.width - 60 ) / 2
            return CGSize(width: width , height: width * ( 2.1 / 2 ))
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if isViewAsList {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else
        {
            return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isViewAsList ? 0 : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return isViewAsList ? 0 : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < listFolder.count {
            
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pdfVC = storyboard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
            pdfVC.config(with: listDocument[indexPath.item - listFolder.count])
            navigationController?.pushViewController(pdfVC, animated: true)
        }
    }
}
