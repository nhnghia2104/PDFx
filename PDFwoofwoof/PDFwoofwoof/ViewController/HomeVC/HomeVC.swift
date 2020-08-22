//
//  HomeVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/10/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit

class HomeVC: UIViewController {

    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var vMoreTools: ShadowView!
    @IBOutlet weak var imgMoreTools: UIImageView!
    @IBOutlet weak var lblMoreTools: UILabel!
    @IBOutlet weak var lineLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnRecent: UIButton!
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
    private var isRecent : Bool = true {
        didSet {
            if isRecent {
                btnRecent.titleLabel?.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
                btnFavorite.titleLabel?.font = UIFont.getFontOpenSans(style: .Regular, size: 14)
                btnRecent.alpha = 1.0
                btnFavorite.alpha = 0.7
            }
            else {
                btnFavorite.titleLabel?.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
                btnRecent.titleLabel?.font = UIFont.getFontOpenSans(style: .Regular, size: 14)
                btnFavorite.alpha = 1.0
                btnRecent.alpha = 0.7
            }
        }
    }
    
    
    //MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigation()
        register()
        setupThemes()
        setupTableView()
//        setupToolColectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var urlPDF : [URL] = []
        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//            // process files
//            urlPDF = fileURLs.filter{ $0.pathExtension == "" }
//            print(urlPDF)
//        } catch {
//            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
//        }
        
        if let documentsURL = fileManager.urls(for: .documentDirectory, skipsHiddenFiles: true) {
            for url in documentsURL {
                if PDFDocument(url: url) != nil {
                    print("ngon")
                }
            }
        }
        isRecent = true
    }
    // MARK: - setup function
    private func setupNavigation() {
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: CMSConfigConstants.themeStyle.black,
         NSAttributedString.Key.font: UIFont.getFontOpenSans(style: .SemiBold, size: 36)]
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.setSlideMenuVCNaviBarItem()
        self.addRightBarButtonWithImage(img: UIImage(named: "ic_notifications_black_24dp")!, action: #selector(openNotice))
    }
    private func register() {
        clvTools.register(UINib(nibName: "ToolCell", bundle: nil), forCellWithReuseIdentifier: "ToolCell")
        tableView.registerCellNib(DocumentTableViewCell.self)
    }
    private func setupToolColectionView() {
        let layoutDrag: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutDrag.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutDrag.minimumInteritemSpacing = 0
        layoutDrag.minimumLineSpacing = 10
        layoutDrag.scrollDirection = .horizontal
        clvTools.collectionViewLayout = layoutDrag
        clvTools.contentInset.top = 10.0
    }
    private func setupTableView() {
        tableView.contentInset.top = tableView.contentInset.top + 20
    }

    private func setupThemes() {
        imgMoreTools.tintColor = CMSConfigConstants.themeStyle.gray1
        lblMoreTools.textColor = CMSConfigConstants.themeStyle.gray1
        lblMoreTools.alpha = 1.0
        imgMoreTools.alpha = 1.0
        
        btnRecent.titleLabel?.textColor = CMSConfigConstants.themeStyle.black
        btnFavorite.titleLabel?.textColor = CMSConfigConstants.themeStyle.black
        
        btnMore.tintColor = CMSConfigConstants.themeStyle.gray1
        
        vLine.backgroundColor = CMSConfigConstants.themeStyle.borderColor
    }
    
    
    // MARK: - @objc function
    @objc func openNotice() {
        
    }
    
    //MARK: -IBAction
    @IBAction func tapMoreTools(_ sender: UIGestureRecognizer) {
        gotoMoreTools()
    }
    @IBAction func changeOption(_ sender: UIButton) {
        if (isRecent && sender.tag == 2) || (!isRecent && sender.tag == 1)  {
            changeValue()
        }
    }
    
    //MARK: - Action Function
    private func changeValue() {
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self?.lineLeadingAnchor.constant = (self?.isRecent)! ? 70.0 : 0
            self?.view.layoutIfNeeded()
        })
        isRecent = !isRecent
        
    }
    private func gotoMoreTools() {
        print("goto More Tools")
    }
    func openBrowser() {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true)
    }
    

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

        return CGSize(width:  85, height: 120 )
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch listTools[indexPath.item].name {
        case "Open File":
            openBrowser()
            break
        default:
            break
        }
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

extension HomeVC : UIDocumentPickerDelegate, LaunchURLDelegate {
    func open(document: URL) {
        guard let pdf = PDFDocument(url: document) else {
            return // TODO: Handle this
        }
        print("Ngon")
       
    }

    // UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        open(document: urls.first!)
    }


}
