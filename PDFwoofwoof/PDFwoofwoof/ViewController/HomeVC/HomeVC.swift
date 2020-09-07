//
//  HomeVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/10/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit
import SwipeCellKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var btnNotice : UIButton!
    var btnTool : UIButton!
    struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 20
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
            collectionView.hideSwipeCell()
        }
    }
    
    lazy var listRecent = [MyDocument]()
    lazy var listFavorite = [MyDocument]()
    private var dataDidLoad = false
    
    
    //MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        loadRecentPDF()
        setupCollectionView()
        setupNavigation()
        register()
        setupThemes()
        didBecomeActive()
        dataDidLoad = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataDidLoad == false {
            didBecomeActive()
        }
        else {
            dataDidLoad = false
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNotification()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView.hideSwipeCell()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("denited HomeVC")
    }
    // MARK: - setup function
    private func setupNavigation() {
        
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.setSlideMenuVCNaviBarItem()
        //self.addRightBarButtonWithImage(img: UIImage(named: "ic_notifications_black_24dp")!, action: #selector(openNotice))
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
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    private func setupThemes() {
        setupNaviBarBtn()
    }

    private func loadRecentPDF() {
        listRecent = RealmManager.shared.getRecentPDF() ?? []
        resortRecentList()
    }
    private func loadFavoriteList() {
        listFavorite = RealmManager.shared.getFavoritePDF() ?? []
        resortFavoriteList()
    }
    private func resortFavoriteList() {
        listFavorite = listFavorite.sorted(by: {$0.getAccessDate().compare($1.getAccessDate()) == .orderedDescending})
    }
    private func resortRecentList() {
        listRecent = listRecent.sorted( by : {
            $0.getAccessDate().compare($1.getAccessDate()) == .orderedDescending
        })
    }
    
    private func setupNaviBarBtn() {
        //https://coolors.co/edf2fb-e2eafc-d7e3fc-ccdbfd-c1d3fe-b6ccfe-abc4ff
        
        btnNotice = UIButton()
        btnNotice.setImage(UIImage(named: "ic_notifications_black_24dp"), for: .normal)
        btnNotice.addTarget(self, action: #selector(openNotice), for: .touchUpInside)
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(btnNotice)
        btnNotice.tintColor = UIColor(hex: "0077b6") //CMSConfigConstants.themeStyle.tintColor
        btnNotice.backgroundColor = UIColor(hex: "edf2fb") //CMSConfigConstants.themeStyle.borderColor
        btnNotice.layer.cornerRadius = 20.0
        btnNotice.clipsToBounds = true
        btnNotice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnNotice.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            btnNotice.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            btnNotice.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            btnNotice.widthAnchor.constraint(equalTo: btnNotice.heightAnchor)
        ])
        
        btnTool = UIButton()
        btnTool.setImage(UIImage(named: "ic_Tool"), for: .normal)
        btnTool.addTarget(self, action: #selector(tapTool), for: .touchUpInside)
        
        navigationBar.addSubview(btnTool)
        btnTool.tintColor = UIColor(hex: "0077b6") //CMSConfigConstants.themeStyle.tintColor
        btnTool.backgroundColor = UIColor(hex: "edf2fb") //CMSConfigConstants.themeStyle.borderColor
        btnTool.layer.cornerRadius = 20.0
        btnTool.clipsToBounds = true
        btnTool.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnTool.rightAnchor.constraint(equalTo: btnNotice.leftAnchor, constant: -16),
            btnTool.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            btnTool.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            btnTool.widthAnchor.constraint(equalTo: btnNotice.heightAnchor)
        ])
    }
    
    // MARK: - @objc function
    @objc func openNotice() {
        goToNotice()
    }
    @objc func tapImport() {
        openBrowser()
    }
    @objc func tapTool() {
        goToTool()
    }
    @objc func didBecomeActive() {
        loadAndCheck()
    }
    @objc func didTapClearRecent() {
        let alertView = UIAlertController(title: "Confirm", message: "Are you sure you want to clear all recent files?", preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Clear", style: .default, handler: { [weak self](alert) in
            self?.removeAllRecent()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in
        })
        alertView.addAction(actionCancel)
        alertView.addAction(actionDelete)
        present(alertView, animated: true, completion: nil)
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
    
    // after become active, load a new list from database
    // compare new list with present list
    // if new list != present list -> reload
    // else do nothing
    private func loadAndCheck() {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            var newRecent = RealmManager.shared.getRecentPDF() ?? []
            newRecent = newRecent.sorted( by : {
                $0.getAccessDate().compare($1.getAccessDate()) == .orderedDescending
            })
            var needReload = false
            // Case 1 :
            if newRecent.count != self?.listRecent.count {
                if self?.isRecent == true {
                    needReload = true
                }
            }
            else {
                
                let result = zip(newRecent, self!.listRecent).enumerated().filter() {
                    $1.0.getFileName() == $1.1.getFileName() && $1.0.getAccessDate() == $1.1.getAccessDate() && $1.0.isFavorite == $1.1.isFavorite
                }.map{$0.0}
                print(result)
                // Case 2
                if result.count == self?.listRecent.count { }
                else {
                    self?.listRecent = newRecent
                    if (self?.isRecent == true) {
                        needReload = true
                    }
                }
            }
            
            var newFavorite = RealmManager.shared.getFavoritePDF() ?? []
            newFavorite = newFavorite.sorted(by: {
                $0.getAccessDate().compare($1.getAccessDate()) == .orderedDescending
            })
            if newFavorite.count != self?.listFavorite.count {
                
                if self?.isRecent == false {
                    needReload = true
                }
            }
            else {
                let result2 = zip(newFavorite, self!.listFavorite).enumerated().filter() {
                    $1.0.getFileName() == $1.1.getFileName() && $1.0.isFavorite == $1.1.isFavorite 
                }.map{$0.0}
                if result2.count == self?.listFavorite.count { }
                else {
                    self?.listFavorite = newFavorite
                    if (self?.isRecent == false) {
                        needReload = true
                    }
                }
            }
            
            self?.listRecent = newRecent
            self?.listFavorite = newFavorite
            if needReload {
                DispatchQueue.main.async {
                    [weak self] in
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
            
            
        }
    }
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
    
    private func goToNotice() {
        let noticeVC = NoticeVC(nibName: "NoticeVC", bundle: nil)
        let nvc: UINavigationController = UINavigationController(rootViewController: noticeVC)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true, completion: nil)
        
    }
    
    private func openBrowser() {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        picker.delegate = self
        picker.modalPresentationStyle = .popover
        present(picker, animated: true)
    }
    private func openPDF(url : URL) {
        let storyboard = UIStoryboard(name: "PDFDocument", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let pdfVC = navigationController.viewControllers.first as! PDFViewController
        pdfVC.config(with: Document(fileURL: url))
        navigationController.modalTransitionStyle = .crossDissolve
        // Presenting modal in iOS 13 fullscreen
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func removeRecent(indexPath : IndexPath) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            DispatchQueue.main.async {
                [weak self] in
                self?.collectionView.deleteItems(at: [indexPath])
            }
            RealmManager.shared.deleteRecent(url: self?.listRecent[indexPath.item].getURLPath() ?? "", completion: nil)
            self?.listRecent.remove(at: indexPath.item)
        }
    }
    private func removeDocument(indexPath : IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            DispatchQueue.main.async {
                [weak self] in
                self?.collectionView.deleteItems(at: [indexPath])
                self?.listFavorite.remove(at: indexPath.item)
            }
            do {
                try FileManager.default.removeItem(at: (self?.listFavorite[indexPath.item].getURL())!)
            }
            catch {
                print("delete fail")
            }
        }
    }
    
    private func removeAllRecent() {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            DispatchQueue.main.async {
                [weak self] in
                self?.listRecent.removeAll()
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }
            RealmManager.shared.clearAllRecent(completion: {[weak self] in
                print("clear all :(")
            })
        }
    }
    
    private func saveFavorite(indexPath : IndexPath) {
        let newDoc = isRecent ? listRecent[indexPath.item] : listFavorite[indexPath.item]
        newDoc.isFavorite.toggle()
        RealmManager.shared.saveFavoritePDF(url: newDoc.getURL(), isFavorite: newDoc.isFavorite)
        if isRecent {
            listRecent[indexPath.item] = newDoc
        } else {
            listFavorite[indexPath.item] = newDoc
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListDocCollectionViewCell else {
            collectionView.reloadItems(at: [indexPath])
            return
        }
        cell.isFavorite = newDoc.isFavorite
    }
    
}
extension HomeVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView = .none
        if listRecent.count == 0 && isRecent {
            collectionView.setEmptyView(title: "No recent files", message: "Any file you have worked recently\nwill be appeared here", image: UIImage(named: "img_noRecent")!)
        }
        if !isRecent && listFavorite.count == 0 {
            collectionView.setEmptyView(title: "No favorite files", message: "Any file you have worked recently\nwill be appeared here", image: UIImage(named: "img_Favorite")!)
        }
        return isRecent ? listRecent.count : listFavorite.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListDocCollectionViewCell", for: indexPath) as? ListDocCollectionViewCell else {return UICollectionViewCell()}
        cell.delegate = self
        cell.setRecentData(pdf: isRecent ?  listRecent[indexPath.item] : listFavorite[indexPath.item], isFavorite: isRecent ?  listRecent[indexPath.item].isFavorite : listFavorite[indexPath.item].isFavorite)
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
        let itemSelected = isRecent ? listRecent[indexPath.item] : listFavorite[indexPath.item]
        openPDF(url: itemSelected.getURL() )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderHomeView", for: indexPath) as? HeaderHomeView else {
            return .init(frame: .zero)
        }
        header.isRecent = isRecent
        header.valueDidChange = {[weak self] (isRecent) in
            self?.isRecent = isRecent
        }
        header.didTapClear = {[weak self] in
            self?.didTapClearRecent()
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
            }
        }
    }
    
    // UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let sourceURL = urls.first else { return }
        open(url: sourceURL)
    }
}


extension HomeVC : SwipeCollectionViewCellDelegate {
    
       func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil }
        let isFavor = isRecent ? listRecent[indexPath.item].isFavorite : listFavorite[indexPath.item].isFavorite
        
        // Favorite action
        let favorite = SwipeAction(style: .default, title: isFavor ? "Unfavorite" : "Favorite") { [weak self](action, indexPath) in
            self?.collectionView.hideSwipeCell()
            self?.saveFavorite(indexPath: indexPath)
            self?.didBecomeActive()
        }
        favorite.image = UIImage(named: isFavor ? "ic_Star-mini" : "ic_unStar-mini" )
        favorite.backgroundColor = CMSConfigConstants.themeStyle.backgroundGray
        favorite.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
        favorite.textColor = CMSConfigConstants.themeStyle.tintGray

        
        // Delete action
        let deleteAction = SwipeAction(style: .destructive, title: isRecent ? "Remove" : "Delete") { [weak self] action, indexPath in
            let alert = UIAlertController(title: "Confirm", message: (self?.isRecent ?? true) ? "Are you sure you want to remove this recent item?" : "Are you sure you want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: (self?.isRecent ?? true) ? "Remove" : "Delete", style: .default, handler: { [weak self] action in
                (self?.isRecent ?? true) ? self?.removeRecent(indexPath: indexPath) : self?.removeDocument(indexPath: indexPath)
            }))
            self?.collectionView.hideSwipeCell()
            self?.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(named: isRecent ? "ic_Remove" : "ic_Delete-mini")
        deleteAction.backgroundColor = CMSConfigConstants.themeStyle.backgroundGray
        deleteAction.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
        deleteAction.textColor = CMSConfigConstants.themeStyle.tintGray
        
        
        // More action
        let moreAction = SwipeAction(style: .default, title: "More") {[weak self] action, indexPath in
            self?.collectionView.hideSwipeCell()
        }
        moreAction.image = UIImage(named: "ic_More-mini")
        moreAction.backgroundColor = CMSConfigConstants.themeStyle.backgroundGray
        moreAction.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
        moreAction.textColor = CMSConfigConstants.themeStyle.tintGray
        
        return [deleteAction,favorite,moreAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        options.backgroundColor = CMSConfigConstants.themeStyle.backgroundGray
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView, willBeginEditingItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListDocCollectionViewCell  else { return }
        cell.isExpanding = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndEditingItemAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
        if indexPath == nil { return }
        guard let cell = collectionView.cellForItem(at: indexPath ?? IndexPath(item: 0, section: 0)) as? ListDocCollectionViewCell  else { return }
        cell.isExpanding = false
    }
}
