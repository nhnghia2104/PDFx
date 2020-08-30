//
//  DocumentsVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/20/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit
import PDFKit
import NVActivityIndicatorView

class DocumentsVC: UIViewController {
    

//    @IBOutlet weak var leadingAnchor: NSLayoutConstraint!
//    @IBOutlet weak var vBackground: UIView!
//    @IBOutlet weak var btnSelect: UIButton!
//    @IBOutlet weak var btnGrid: UIButton!
//    @IBOutlet weak var btnList: UIButton!
//    @IBOutlet weak var imgSortby: UIImageView!
//    @IBOutlet weak var lblSortby: UILabel!

    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var topAnchorOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clvDocument: UICollectionView!
//    var searchController: UISearchController {
//        let search = UISearchController(searchResultsController: nil)
//        search.obscuresBackgroundDuringPresentation = false
//        search.searchResultsUpdater  = self
//        search.dimsBackgroundDuringPresentation = false
//        search.searchBar.searchBarStyle = .minimal
//        search.searchBar.delegate = self/
//        return search
//    }
    lazy var tempListFolder = [MyFolder]()
    lazy var tempListDocument = [MyDocument]()
    lazy var searchBarbtn: UIBarButtonItem = {
        let customBtn = UIBarButtonItem(image: UIImage(named: "navi_Search"), style: .plain, target: self, action: #selector(tapSearch))
        return customBtn
    }()
    lazy var selectBarbtn: UIBarButtonItem = {
        let customBtn = UIBarButtonItem(image: UIImage(named: "navi_Select"), style: .plain, target: self, action: #selector(tapSelect))
        return customBtn
    }()
    var listFolder = [MyFolder]()
    var listDocument = [MyDocument]()
    var location = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var isChildClass = false
    private var isSortByDate = true
    private var orderedAscending = true
    private var isViewAsList = true
    private var isSelectMode = false {
        didSet {
//            clvDocument.reloadSections(IndexSet(integer: 0))
            clvDocument.reloadData()
        }
    }
    private var selectedCount = 0 {
        didSet {
            isSelectAll = selectedCount == listFolder.count + listDocument.count
            navigationItem.title = "\(selectedCount) selected"
        }
    }
    private var isSelectAll = false {
        didSet {
            addLeftBarButtonWithTittle(title: isSelectAll ? "Deselect all" : "Select all", action: #selector(tapSelectAll))
        }
    }

    // MARK: - override function
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("denited DocumentVC---is Child : \(isChildClass)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.type = .circleStrokeSpin
        activityIndicatorView.color = UIColor(hex: "3282b8", alpha: 1)
        activityIndicatorView.startAnimating()
        register()
        setupCollectionView()
        setupTheme()
//        loadFileFromDevice()
        
        setupViewMode()
        setupNavigation()
        addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didBecomeActive()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNotification()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - setup functions
    public func setLocation(url : URL, isChildClass : Bool) {
        self.location = url
        self.isChildClass = isChildClass
    }
    private func setupNavigation() {
        self.navigationController?.view.layer.shadowColor = .none
        self.navigationItem.title = isChildClass ? location.lastPathComponent : "Documents"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        isChildClass ? () : self.setSlideMenuVCNaviBarItem()
        isChildClass ? self.navigationItem.setHidesBackButton(false, animated: true) : ()
        self.navigationItem.rightBarButtonItems = [selectBarbtn,searchBarbtn]
        setupBaseNavigation()
        searchBar.delegate = self
        searchBar.isHidden = true
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
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        clvDocument.collectionViewLayout = layout
        
    }
    private func register() {
        clvDocument.register(UINib(nibName: "ListDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListDocCollectionViewCell")
        clvDocument.register(UINib(nibName: "GridDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridDocCollectionViewCell")
        clvDocument.register(UINib(nibName: "HeaderDocumentView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderDocumentView")
    }
    private func setupTheme() {
       searchBar.tintColor = CMSConfigConstants.themeStyle.tintColor
       if let textFieldInsideSearchBar =  searchBar.value(forKey: "searchField") as? UITextField {
           textFieldInsideSearchBar.font = UIFont.getFontRegular(size: 14)
           textFieldInsideSearchBar.textColor = CMSConfigConstants.themeStyle.titleColor
           if let labelInsideSearchBar = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel {
               labelInsideSearchBar.font = UIFont.getFontRegular(size: 14)
               labelInsideSearchBar.textColor = CMSConfigConstants.themeStyle.tintColor
               
           }
       }
       UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
           NSAttributedString.Key.foregroundColor : CMSConfigConstants.themeStyle.titleColor,
           NSAttributedString.Key.font : UIFont.getFontRegular(size: 14)
       ], for: .normal)
        
    }
    private func setupViewMode() {
        // List/Grid Mode
        if UserDefaults.standard.object(forKey: "isViewAsList") == nil {
            UserDefaults.standard.setValue(true, forKey: "isViewAsList")
        }
        if let bool = UserDefaults.standard.object(forKey: "isViewAsList") as? Bool {
            isViewAsList = bool
        }
        
        //Sort by Date/Name
        if UserDefaults.standard.object(forKey: "SortMode") == nil {
            UserDefaults.standard.set([true,true], forKey: "SortMode")
        }
        if let mode = UserDefaults.standard.object(forKey: "SortMode") as? [Bool] {
            isSortByDate = mode[0]
            orderedAscending = mode[1]
            resortData()
        }
    }
    
//    private func showSearchControl() {
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = true
//        definesPresentationContext = true
//    }
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - IBAction
    func didTapListMode() {
        UserDefaults.standard.setValue(true, forKey: "isViewAsList")
        isViewAsList = true
        clvDocument.reloadData()
    }
    func didTapGridMode() {
        UserDefaults.standard.setValue(false, forKey: "isViewAsList")
        isViewAsList = false
        clvDocument.reloadData()
    }
    //MARK: - objc funtion
    @objc func openMore() {
        
    }
    @objc func tapSelect() {
        gotoSelectMode()
    }
    @objc func didBecomeActive() {
        loadAndCheck()
    }
    @objc func tapDone() {
        comebackViewMode()
    }
    @objc func tapSelectAll() {
        isSelectAll = !isSelectAll
        if isSelectAll {
            for row in 0..<clvDocument.numberOfItems(inSection: 0) {
                self.clvDocument.selectItem(at: IndexPath(item: row, section: 0), animated: true, scrollPosition: .bottom)
            }
            selectedCount = clvDocument.numberOfItems(inSection: 0)
        }
        else {
            for row in 0..<clvDocument.numberOfItems(inSection: 0) {
                self.clvDocument.deselectItem(at: IndexPath(row: row, section: 0), animated: false)
            }
            selectedCount = 0
        }
    }
    @objc func tapSearch() {
        startSearch()
    }
    //MARK: - Action function
    /*
        compare 2 list ( new list and present list )
        find the same elements
        reload when new list != present list
     */
    private func loadAndCheck() {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            var newListDoc = [MyDocument]()
            var newListFolder = [MyFolder]()
            if let documentURLs = FileManager.default.getFileURLs(from: self!.location) {
                newListFolder = self?.loadFolder(urls: documentURLs.filter{ $0.pathExtension == "" }) ?? []
                newListDoc = self?.loadPDFDocument(urls: documentURLs.filter{ $0.pathExtension == "pdf" }) ?? []
            }
            if newListFolder.count != self?.listFolder.count || newListDoc.count != self?.listDocument.count {
                if newListFolder.count != self?.listFolder.count {
                    self?.listFolder = newListFolder
                }
                if newListDoc.count != self?.listDocument.count {
                    self?.listDocument = newListDoc
                }
                DispatchQueue.main.async {
                    [weak self] in
                    if (self?.activityIndicatorView.isAnimating)! {
                        self?.activityIndicatorView.stopAnimating()
                    }
                    self?.clvDocument.reloadSections(IndexSet(integer: 0))
                }
            }
            else {
                var needReload = false
                let result1 = zip(newListFolder, self!.listFolder).enumerated().filter() {
                    $1.0.getName() == $1.1.getName()
                }.map{$0.0}
                if result1.count == self?.listFolder.count { }
                else {
                    needReload = true
                    self?.listFolder = newListFolder
                }
                let result2 = zip(newListDoc, self!.listDocument).enumerated().filter() {
                    $1.0.getFileName() == $1.1.getFileName()
                }.map{$0.0}
                if result2.count == self?.listDocument.count { }
                else {
                    needReload = true
                    self?.listDocument = newListDoc
                }
                if needReload {
                    DispatchQueue.main.async {
                        [weak self] in
                        if (self?.activityIndicatorView.isAnimating)! {
                            self?.activityIndicatorView.stopAnimating()
                        }
                        self?.clvDocument.reloadSections(IndexSet(integer: 0))
                    }
                }
                
            }
        }
    }
    private func loadFileFromDevice() {
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            if let documentURLs = FileManager.default.getFileURLs(from: self!.location) {
                self?.listFolder = self?.loadFolder(urls: documentURLs.filter{ $0.pathExtension == "" }) ?? []
                self?.listDocument = self?.loadPDFDocument(urls: documentURLs.filter{ $0.pathExtension == "pdf" }) ?? []
            }
        }
    }
    private func loadFileFromDeviceWithoutAnimate() {
        
        if let documentURLs = FileManager.default.getFileURLs(from: location) {
            listDocument.removeAll()
            listFolder.removeAll()
            var urls = documentURLs.filter{ $0.pathExtension == "" }
            for url in urls {
                let child = MyFolder(url: url)
                listFolder.append(child)
            }
            urls = documentURLs.filter{ $0.pathExtension == "pdf" }
            for url in urls {
                let child = MyDocument(url: url)
                listDocument.append(child)
            }
            resortData()
        }
        
    }
    private func loadPDFDocument(urls : [URL]) -> [MyDocument]{
        var newList = [MyDocument]()
        for url in urls {
            if PDFDocument(url: url) != nil {
                let child = MyDocument(url: url)
                newList.append(child)
            }
        }
        if isSortByDate {
            newList = newList.sorted( by :{
                orderedAscending ? $0.getDateCreated().compare($1.getDateCreated()) == .orderedAscending : $0.getDateCreated().compare($1.getDateCreated()) == .orderedDescending
            })
        }
        else {
            newList = newList.sorted(by: {
                orderedAscending ? $0.getFileName().localizedStandardCompare($1.getFileName()) == .orderedAscending : $0.getFileName().localizedStandardCompare($1.getFileName()) == .orderedDescending
            })
        }
        return newList
    }
    private func loadFolder(urls : [URL]) -> [MyFolder] {
        var newList = [MyFolder]()
        for url in urls {
            let child = MyFolder(url: url)
            newList.append(child)
//            DispatchQueue.main.async {[weak self] in
//                self?.clvDocument.insertItems(at: [IndexPath(row: (self!.listDocument.count + self!.listFolder.count) - 1, section: 0)])
//            }
        }
        if isSortByDate {
            newList = newList.sorted(by :{
                orderedAscending ? $0.getDateCreated().compare($1.getDateCreated()) == .orderedAscending : $0.getDateCreated().compare($1.getDateCreated()) == .orderedDescending
                
            })
        }
        else {
            newList = newList.sorted (by: {
                orderedAscending ? $0.getName().localizedStandardCompare($1.getName()) == .orderedAscending : $0.getName().localizedStandardCompare($1.getName()) == .orderedDescending
                
            })
        }
        return newList
    }
    private func resortData() {
        isSortByDate ? sortByDate() : sortByName()
        UserDefaults.standard.setValue([isSortByDate,orderedAscending], forKey: "SortMode")
//        DispatchQueue.main.async {[weak self] in
//            self?.clvDocument.reloadSections(IndexSet(integer: 0))
//            self?.clvDocument.layoutIfNeeded()
//        }
        
    }
    private func sortByDate() {

        listFolder = listFolder.sorted(by :{
            orderedAscending ? $0.getDateCreated().compare($1.getDateCreated()) == .orderedAscending : $0.getDateCreated().compare($1.getDateCreated()) == .orderedDescending
            
        })
        listDocument = listDocument.sorted( by :{
            orderedAscending ? $0.getDateCreated().compare($1.getDateCreated()) == .orderedAscending : $0.getDateCreated().compare($1.getDateCreated()) == .orderedDescending
        })
    }
    private func sortByName() {
        listFolder = listFolder.sorted (by: {
            orderedAscending ? $0.getName().localizedStandardCompare($1.getName()) == .orderedAscending : $0.getName().localizedStandardCompare($1.getName()) == .orderedDescending
            
        })
        listDocument = listDocument.sorted(by: {
            orderedAscending ? $0.getFileName().localizedStandardCompare($1.getFileName()) == .orderedAscending : $0.getFileName().localizedStandardCompare($1.getFileName()) == .orderedDescending
        })
            
    }
    private func sortOnlyFolder() {
        if isSortByDate {
            listFolder = listFolder.sorted(by :{
                orderedAscending ? $0.getDateCreated().compare($1.getDateCreated()) == .orderedAscending : $0.getDateCreated().compare($1.getDateCreated()) == .orderedDescending
                
            })
        }
        else {
            listFolder = listFolder.sorted (by: {
                orderedAscending ? $0.getName().localizedStandardCompare($1.getName()) == .orderedAscending : $0.getName().localizedStandardCompare($1.getName()) == .orderedDescending
                
            })
        }
    }
    private func sortOnlyDocument() {
        if isSortByDate {
            listDocument = listDocument.sorted( by :{
                orderedAscending ? $0.getDateCreated().compare($1.getDateCreated()) == .orderedAscending : $0.getDateCreated().compare($1.getDateCreated()) == .orderedDescending
            })
        }
        else {
            listDocument = listDocument.sorted(by: {
                orderedAscending ? $0.getFileName().localizedStandardCompare($1.getFileName()) == .orderedAscending : $0.getFileName().localizedStandardCompare($1.getFileName()) == .orderedDescending
            })
        }
    }
    func changeSortMode(bool : [Bool]) {
        isSortByDate = bool[0]
        orderedAscending = bool[1]
        resortData()
        clvDocument.reloadSections(IndexSet(integer: 0))
    }
    func gotoSelectMode() {
        navigationController?.navigationItem.title = "Select items"
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.isSelectMode = true
            self?.navigationItem.searchController = nil
            self?.navigationController?.navigationBar.prefersLargeTitles = false
            self?.navigationController?.view.layoutIfNeeded()
            
        }
        removeNaviBarItem()
        addRightBarButtonWithTittle(title: "Done", action: #selector(tapDone))
        addLeftBarButtonWithTittle(title: "Select all", action: #selector(tapSelectAll))
        clvDocument.allowsMultipleSelection = true
    }
    func comebackViewMode() {
//        removeNaviBarItem()
        selectedCount = 0
        navigationItem.leftBarButtonItem = nil
        setupNavigation()
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.isSelectMode = false
            self?.navigationController?.view.layoutIfNeeded()
        }
        clvDocument.allowsMultipleSelection = false
    }
    func startSearch() {
        searchBar.isHidden = false
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.navigationController?.setNavigationBarHidden(true, animated: false)
            self?.topAnchorOfCollectionView.constant = 44
            self?.view.layoutIfNeeded()
        }
        searchBar.becomeFirstResponder()
    }
    func stopSearch() {
        searchBar.isHidden = true
//        UIView.animate(withDuration: 0.2) {[weak self] in
//            self?.topAnchorOfCollectionView.constant = 0
//            self?.navigationController?.setNavigationBarHidden(false, animated: false)
//        }
        topAnchorOfCollectionView.constant = 0
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.view.layoutIfNeeded()
        
    }
    func openPDF(pdfData : Document) {
        let storyboard = UIStoryboard(name: "PDFDocument", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let pdfVC = navigationController.viewControllers.first as! PDFViewController
        pdfVC.config(with: pdfData )
        navigationController.modalTransitionStyle = .crossDissolve
        // Presenting modal in iOS 13 fullscreen
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    func saveRecentPDF(url : URL) {
        RealmManager.shared.saveRecentPDF(url: url)
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
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isViewAsList ? 0 : 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return isViewAsList ? 0 : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isSelectMode {
            if indexPath.item < listFolder.count {
                let directVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DocumentsVC") as! DocumentsVC
                directVC.setLocation(url: listFolder[indexPath.item].url, isChildClass: true)
                navigationController?.pushViewController(directVC, animated: true)
            }
            else {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.saveRecentPDF(url: (self?.listDocument[indexPath.item - (self?.listFolder.count)!].getPDFData().fileURL)!)
                    print("Date Access : \(self?.listDocument[indexPath.item - (self?.listFolder.count)!].getAccessDate())")
                }
                openPDF(pdfData: listDocument[indexPath.item - listFolder.count].getPDFData())
            }
        }
        else {
            selectedCount += 1
        }
        if !(searchBar.text?.isEmpty ?? true) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
            listDocument = tempListDocument
            listFolder = tempListFolder
            clvDocument.reloadSections(IndexSet(integer: 0))
            stopSearch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isSelectMode {
            selectedCount -= 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderDocumentView", for: indexPath) as? HeaderDocumentView else {
            return .init(frame: .zero)
        }
        header.didChangeViewMode = { [weak self] (viewAsList) in
            viewAsList ? self?.didTapListMode() : self?.didTapGridMode()
        }
        header.didChangeSortMode = { [weak self] (bool) in
            self?.changeSortMode(bool: bool)
        }
        header.didTapSelectMode = {[weak self] in
            self?.gotoSelectMode()
        }
        header.setupSortModeUI(sortMode: [isSortByDate,orderedAscending], isViewAsList: isViewAsList)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: isSelectMode ? 0 : 50)
    }
}
//extension DocumentsVC : UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let text = searchController.searchBar.text, !text.isEmpty {
//            listDocument = (tempListDocument.filter({String($0.getFileName()).lowercased().contains(text.lowercased())}))
//            listFolder = (tempListFolder.filter({String($0.getName()).lowercased().contains(text.lowercased())}))
//        }else {
//            listDocument = tempListDocument
//            listFolder = tempListFolder
//        }
//        clvDocument.reloadData()
//    }
//
//
//}
extension DocumentsVC : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        tempListFolder = listFolder
        tempListDocument = listDocument
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        listDocument = tempListDocument
        listFolder = tempListFolder
        clvDocument.reloadSections(IndexSet(integer: 0))
        stopSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            listDocument = (tempListDocument.filter({String($0.getFileName()).lowercased().contains(searchText.lowercased())}))
            listFolder = (tempListFolder.filter({String($0.getName()).lowercased().contains(searchText.lowercased())}))
        }else {
            listDocument = tempListDocument
            listFolder = tempListFolder
        }
        clvDocument.reloadSections(IndexSet(integer: 0))
    }
}
//extension DocumentsVC : UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
//
//    func navigationController(
//        _ navigationController: UINavigationController,
//        animationControllerFor operation: UINavigationController.Operation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        simpleOver.popStyle = (operation == .pop)
//
//        return simpleOver
//    }
//}
