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
    
    var listFolder = [MyFolder]()
    var listDocument = [MyDocument]()
    var direct = FileManager.default
    
    private var isViewAsList = true {
        didSet {
            changeListGridIcon()
        }
    }
    private var isSelectMode = false {
        didSet {
            clvDocument.reloadData()
        }
    }
    // MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFileFromDevice()
        setupNavigation()
        register()
        setupTheme()
        setupViewMode()
        setupCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = isViewAsList ? CGSize(width: clvDocument.frame.width, height: 75) : CGSize(width: ( clvDocument.frame.width - 80 ) / 3 , height: (( clvDocument.frame.width - 80 ) / 3) * ( 1.7 / 1 ))
        layout.sectionInset = isViewAsList ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = isViewAsList ? 0 : 20
        layout.minimumLineSpacing = isViewAsList ? 0 : 20
        layout.scrollDirection = .vertical
        clvDocument.collectionViewLayout = layout
        
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
    private func setupViewMode() {
        // List/Grid Mode
        if UserDefaults.standard.object(forKey: "isViewAsList") == nil {
            UserDefaults.standard.setValue(true, forKey: "isViewAsList")
        }
        if let bool = UserDefaults.standard.object(forKey: "isViewAsList") as? Bool {
            isViewAsList = bool
        }
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
                let child = MyDocument(url: url)
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
        resetCollectionViewLayout()
    }
    @IBAction func tapGridMode() {
        UserDefaults.standard.setValue(false, forKey: "isViewAsList")
        isViewAsList = false
        resetCollectionViewLayout()
    }
    @IBAction func tapSelect() {
        isSelectMode = !isSelectMode
    }
    //MARK: - objc funtion
    @objc func openMore() {
        
    }
    //MARK: - Action function
    private func changeListGridIcon() {
        UIView.animate(withDuration: 0.1, animations: {[weak self] in
            self?.leadingAnchor.constant = (self?.isViewAsList)! ? 30.0 : 0
            self?.view.layoutIfNeeded()
        })
        
    }
    private func resetCollectionViewLayout() {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = isViewAsList ? CGSize(width: clvDocument.frame.width, height: 75) : CGSize(width: ( clvDocument.frame.width - 80 ) / 3 , height: (( clvDocument.frame.width - 80 ) / 3) * ( 1.7 / 1 ))
//        layout.sectionInset = isViewAsList ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
//        layout.minimumInteritemSpacing = isViewAsList ? 0 : 20
//        layout.minimumLineSpacing = isViewAsList ? 0 : 20
//        layout.scrollDirection = .vertical
//        clvDocument.setCollectionViewLayout(layout, animated: true) {[weak self] (bool) in
//            if bool {
//                self?.clvDocument.reloadData()
//            }
//        }
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
                cell.setFolderData(folder: listFolder[indexPath.item], isSelectMode: isSelectMode)
            }
            else {
                cell.setDocuemtData(pdf: listDocument[indexPath.item - listFolder.count], isFavorite: false , isSelectMode: isSelectMode)
            }
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridDocCollectionViewCell", for: indexPath) as? GridDocCollectionViewCell else {return UICollectionViewCell()}
            if indexPath.item < listFolder.count {
                cell.setFolderData(folder: listFolder[indexPath.item], isSelectMode: isSelectMode)
            }
            else {
                cell.setDocuemtData(pdf: listDocument[indexPath.item - listFolder.count], isFavorite: false, isSelectMode: isSelectMode)
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
            let width = ( clvDocument.frame.width - 80 ) / 3
            return CGSize(width: width , height: width * ( 1.7 / 1 ))
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
            
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            
            let pdfVC = navigationController.viewControllers.first as! PDFViewController
            pdfVC.config(with: listDocument[indexPath.item - listFolder.count].getPDFData())
            
            navigationController.modalTransitionStyle = .crossDissolve
            // Presenting modal in iOS 13 fullscreen
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
}
