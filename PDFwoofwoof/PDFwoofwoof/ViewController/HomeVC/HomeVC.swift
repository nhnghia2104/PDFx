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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var btnImport : UIButton!
    var btnTool : UIButton!
    struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 0.5
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    weak var delegate: LeftMenuProtocol?

    var isRecent : Bool = true {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var listRecent = [MyDocument]()
    lazy var listFavorite = [MyDocument]()
    
    
    
    //MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadRecentPDF()
        setupCollectionView()
        setupNavigation()
        register()
        setupThemes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resortRecentList()
        collectionView.reloadData()
    }
    deinit {
        print("denited HomeVC")
    }
    // MARK: - setup function
    private func setupNavigation() {
        
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.setSlideMenuVCNaviBarItem()
//        self.addRightBarButtonWithImage(img: UIImage(named: "ic_notifications_black_24dp")!, action: #selector(openNotice))
        setupBaseNavigation()
    }
    private func register() {
        collectionView.register(UINib(nibName: "ListDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListDocCollectionViewCell")
        collectionView.register(UINib(nibName: "GridDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridDocCollectionViewCell")
        collectionView.register(UINib(nibName: "HeaderHomeView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderHomeView")
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        collectionView.contentInset.bottom = collectionView.contentInset.bottom + 40.0

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 75)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        collectionView.collectionViewLayout = layout
        
    }
    
    private func setupThemes() {
        setupNaviBarBtn()
    }

    private func loadRecentPDF() {
        listRecent = RealmManager.shared.getRecentPDF() ?? []
        resortRecentList()
    }
    private func loadFavoriteList() {
//        listFavorite =
    }
    func resortRecentList() {
        listRecent = listRecent.sorted( by : {
            $0.getModified().compare($1.getModified()) == .orderedDescending
        })
    }
    
    func setupNaviBarBtn() {
        btnImport = UIButton()
        btnImport.setImage(UIImage(named: "ic_download"), for: .normal)
        btnImport.addTarget(self, action: #selector(tapImport), for: .touchUpInside)
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(btnImport)
        btnImport.tintColor = CMSConfigConstants.themeStyle.tintColor
        btnImport.backgroundColor = CMSConfigConstants.themeStyle.borderColor
        btnImport.layer.cornerRadius = 20.0
        btnImport.clipsToBounds = true
        btnImport.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnImport.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            btnImport.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            btnImport.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            btnImport.widthAnchor.constraint(equalTo: btnImport.heightAnchor)
        ])
        
        btnTool = UIButton()
        btnTool.setImage(UIImage(named: "ic_download"), for: .normal)
        btnTool.addTarget(self, action: #selector(tapTool), for: .touchUpInside)
        
        navigationBar.addSubview(btnTool)
        btnTool.tintColor = CMSConfigConstants.themeStyle.tintColor
        btnTool.backgroundColor = CMSConfigConstants.themeStyle.borderColor
        btnTool.layer.cornerRadius = 20.0
        btnTool.clipsToBounds = true
        btnTool.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnTool.rightAnchor.constraint(equalTo: btnImport.leftAnchor, constant: -16),
            btnTool.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            btnTool.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            btnTool.widthAnchor.constraint(equalTo: btnImport.heightAnchor)
        ])
    }
    
    // MARK: - @objc function
    @objc func openNotice() {
        
    }
    @objc func tapImport() {
        openBrowser()
    }
    @objc func tapTool() {
        goToTool()
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
//            self?.lineLeadingAnchor.constant = (self?.isRecent)! ? 70.0 : 0
            self?.view.layoutIfNeeded()
        })
        isRecent = !isRecent
    }
    private func gotoMoreTools() {
        print("goto More Tools")
    }
    private func goToTool() {
        let storyboard = UIStoryboard(name: "Tool", bundle: nil)
        
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    func openBrowser() {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        picker.delegate = self
        picker.modalPresentationStyle = .popover
        present(picker, animated: true)
    }
    func openPDF(url : URL) {
        let document = Document(fileURL: url)
        let storyboard = UIStoryboard(name: "PDFDocument", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let pdfVC = navigationController.viewControllers.first as! PDFViewController
        pdfVC.config(with: document )
        navigationController.modalTransitionStyle = .crossDissolve
        // Presenting modal in iOS 13 fullscreen
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func saveRecentPDF(url : URL) {
        RealmManager.shared.saveRecentPDF(url: url) {[weak self] (bool) in
            if bool {
                self?.listRecent.append(MyDocument(url: url))
            }
            self?.resortRecentList()
        }
    }
    
}
extension HomeVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView = .none
        if listRecent.count == 0 && isRecent {
            collectionView.setEmptyView(title: "No recent files", message: "Any file you have worked recently\nwill be appeared here", image: UIImage(named: "image_noRecent")!)
        }
        if !isRecent && listFavorite.count == 0 {
            collectionView.setEmptyView(title: "No favorite files", message: "Any file you have worked recently\nwill be appeared here", image: UIImage(named: "image_noRecent")!)
        }
        return isRecent ? listRecent.count : listFavorite.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListDocCollectionViewCell", for: indexPath) as? ListDocCollectionViewCell else {return UICollectionViewCell()}
        
        cell.setDocuemtData(pdf: isRecent ?  listRecent[indexPath.item] : listFavorite[indexPath.item])
        return cell
    }
    
}

extension HomeVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openPDF(url: listRecent[indexPath.item].getPDFData().fileURL)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.saveRecentPDF(url: (self?.listRecent[indexPath.item].getPDFData().fileURL)!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderHomeView", for: indexPath) as? HeaderHomeView else {
            return .init(frame: .zero)
        }
        
        header.valueDidChange = {[weak self] (isRecent) in
            self?.isRecent = isRecent
        }

        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 44)
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
    func open(url: URL) {
        DispatchQueue.main.async { [weak self] in
            self?.openPDF(url: url)
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FileManager.default.saveFile(from: url) { [weak self] (done,urlSaved) in
                if done {
                    self?.saveRecentPDF(url: urlSaved)
                    print("Save done----------\n\(urlSaved.path)\n=================================================")
                }
                else {
                    print("Toanggggggggggggggggg")
                    
                    
                }
            }
        }
    }
    
    // UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let sourceURL = urls.first else { return }
        open(url: sourceURL)
    }
}


