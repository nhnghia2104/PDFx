//
//  HomeVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/10/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var vMoreTools: UIView!
    @IBOutlet weak var lblMoreTools: UILabel!
    @IBOutlet weak var lblClvHeader: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clvTools: UICollectionView!
    var listTools : [Tool] = [
        Tool(name: "Open File", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "0f4c75"), background: UIColor(hex: "3282b8",alpha: 0.5)),
        Tool(name: "Fill & Sign", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "3b6978"), background: UIColor(hex: "84a9ac",alpha: 0.5)),
        Tool(name: "Scan", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "c7b198"), background: UIColor(hex: "dfd3c3",alpha: 0.5)),
        Tool(name: "Create PDF", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "e79cc2"), background: UIColor(hex: "f6bed6",alpha: 0.5)),
        Tool(name: "Arrange Page", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "3b5249"), background: UIColor(hex: "519872",alpha: 0.5)),
        Tool(name: "Protect PDF", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "776d8a"), background: UIColor(hex: "f3e6e3",alpha: 0.5)),
        Tool(name: "Split PDF", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "a35d6a"), background: UIColor(hex: "d9c6a5",alpha: 0.5)),
        Tool(name: "Merge PDFs", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "810000"), background: UIColor(hex: "e97171",alpha: 0.5)),
        Tool(name: "Extract Page", icon: UIImage(named: "ic_folder")!, tintColor: UIColor(hex: "8675a9"), background: UIColor(hex: "c3aed6",alpha: 0.5)),
    ]
    var listRecent : [String] = []
    var listFavorite : [String] = []
    var shouldHaveAds = false
    
    //MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigation()
        register()
        setupFontAndColor()
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - setup function
    private func setupNavigation() {
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: CMSConfigConstants.themeStyle.gray1,
         NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .SemiBold, size: 36)]
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.setSlideMenuVCNaviBarItem()
        self.addRightBarButtonWithImage(img: UIImage(named: "ic_notifications_black_24dp")!, action: #selector(openNotice))
    }
    private func register() {
        clvTools.register(UINib(nibName: "ToolCell", bundle: nil), forCellWithReuseIdentifier: "ToolCell")
        tableView.registerCellNib(AdvertiseCell.self)
        tableView.registerCellNib(DocumentListCell.self)
        tableView.registerCellNib(SeeMoreCell.self)
    }

    private func setupFontAndColor() {
        lblClvHeader.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
        lblClvHeader.textColor = CMSConfigConstants.themeStyle.gray1
        
        lblMoreTools.font = UIFont.getFontOpenSans(style: .Regular, size: 14)
        lblMoreTools.textColor = CMSConfigConstants.themeStyle.gray1
    }
    
    private func setupLayout() {

    }
    
    // MARK: - @objc function
    @objc func openNotice() {
    
    }
    
    //MARK: -IBAction
    @IBAction func tapMoreTools(_ sender: Any) {
        
    }
    
    //MARK: - Action Function

    

}
extension HomeVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolCell", for: indexPath) as? ToolCell else {return UICollectionViewCell()}
        cell.setData(tool: listTools[indexPath.item])
        return cell
    }
}
extension HomeVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width:  85, height: 110 )
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension HomeVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

