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
import SwipeCellKit

class DocumentsVC: UIViewController {

    @IBOutlet weak var btnMerge: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var clvBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var vBottomTool: UIView!
//    @IBOutlet weak var vToolBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var topAnchorOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clvDocument: UICollectionView!
    lazy var tempListFolder = [MyFolder]()
    lazy var tempListDocument = [MyDocument]()
    lazy var btnAdd : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_Add"), for: .normal)
        button.addTarget(self, action: #selector(tapAdd), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
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
    private var isSortByDate = false
    private var orderedAscending = true
    private var isViewAsList = true
    private var isSelectMode = false {
        didSet {
            clvDocument.reloadData()
        }
    }
    private var selectedCount = 0 {
        didSet {
            isSelectAll = selectedCount == (listDocument.count + listFolder.count) - 1
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
        showIndicator()
        register()
        setupCollectionView()
        setupTheme()
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
        clvDocument.hideSwipeCell()
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
//        self.clvDocument.decelerationRate = UIScrollView.DecelerationRate.normal
        clvDocument.contentInset.bottom = clvDocument.contentInset.bottom + 20.0
        clvDocument.contentInset.top = clvDocument.contentInset.top + 20.0

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = isViewAsList ? CGSize(width: clvDocument.frame.width, height: 75) : CGSize(width: ( clvDocument.frame.width - 80 ) / 3 , height: (( clvDocument.frame.width - 80 ) / 3) * ( 1.7 / 1 ))
        layout.sectionInset = isViewAsList ? UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0) : UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
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
       searchBar.tintColor = CMSConfigConstants.shared.themeStyle.tintColor
       if let textFieldInsideSearchBar =  searchBar.value(forKey: "searchField") as? UITextField {
           textFieldInsideSearchBar.font = UIFont.getFontRegular(size: 14)
           textFieldInsideSearchBar.textColor = CMSConfigConstants.shared.themeStyle.titleColor
           if let labelInsideSearchBar = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as? UILabel {
               labelInsideSearchBar.font = UIFont.getFontRegular(size: 14)
               labelInsideSearchBar.textColor = CMSConfigConstants.shared.themeStyle.tintColor
               
           }
       }
       UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
           NSAttributedString.Key.foregroundColor : CMSConfigConstants.shared.themeStyle.titleColor,
           NSAttributedString.Key.font : UIFont.getFontRegular(size: 14)
       ], for: .normal)
        
        btnDelete.tintColor = CMSConfigConstants.shared.themeStyle.tintGray
        btnMerge.tintColor = CMSConfigConstants.shared.themeStyle.tintGray
        
        // setup btn Add
        view.addSubview(btnAdd)
        var btnAddContraints : [NSLayoutConstraint] = [
            btnAdd.widthAnchor.constraint(equalToConstant: 56),
            btnAdd.heightAnchor.constraint(equalToConstant: 56)
        ]
        
        if #available(iOS 11.0, *) {
            if isiPadUI {
                let btnAddCenterXConstraint = btnAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                btnAddContraints.append(btnAddCenterXConstraint)
            }
            else {
                let btnAddRightConstraint = btnAdd.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
                btnAddContraints.append(btnAddRightConstraint)
            }
            
            let btnAddBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: btnAdd.bottomAnchor, constant: UIDevice.current.IS_169_RATIO() ? 0 : 20)
            btnAddContraints.append(btnAddBottomConstraint)

            
        } else {
            if isiPadUI {
                let btnAddCenterXConstraint = btnAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                btnAddContraints.append(btnAddCenterXConstraint)
            }
            else {
                let btnAddRightConstraint = btnAdd.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
                btnAddContraints.append(btnAddRightConstraint)
            }
            let btnAddBottomConstraint = view.bottomAnchor.constraint(equalTo: btnAdd.bottomAnchor, constant: 20)
            btnAddContraints.append(btnAddBottomConstraint)
        }
        NSLayoutConstraint.activate(btnAddContraints)
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
        clvBottomAnchor.constant = UIDevice.current.IS_169_RATIO() ? -40 : 0
//        vToolBottomAnchor.constant = -140
        vBottomTool.backgroundColor = UIColor(hex: "F8F9FA")
        vBottomTool.isHidden = true
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - IBAction
    @IBAction func tapDelete() {
        actionDelete()
    }
    
    //MARK: - objc funtion
    @objc func tapAdd() {
//        actionCreateFolder()
        openInputVC()
    }
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
                if row < listFolder.count {
                    if listFolder[row].getName() == CMSConfigConstants.shared.defaultFolderName { continue }
                }
                self.clvDocument.selectItem(at: IndexPath(item: row, section: 0), animated: true, scrollPosition: .centeredVertically)
            }
            selectedCount = clvDocument.numberOfItems(inSection: 0) - 1 //can't select default folder
        }
        else {
            for row in 0..<clvDocument.numberOfItems(inSection: 0) {
                if row < listFolder.count {
                    if listFolder[row].getName() == CMSConfigConstants.shared.defaultFolderName { continue }
                }
                self.clvDocument.deselectItem(at: IndexPath(row: row, section: 0), animated: false)
            }
            selectedCount = 0
        }
    }
    @objc func tapSearch() {
        startSearch()
    }
    //MARK: - Action function
    
    private func showIndicator() {
        activityIndicatorView.type = .circleStrokeSpin
        activityIndicatorView.color = UIColor(hex: "0077B6", alpha: 1)
        activityIndicatorView.startAnimating()
    }

    // <Load Data>
    /*
        compare 2 list ( new list and present list )
     find the same elements
     reload when new list != present list
     */
    private func loadAndCheck() {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            var newListDoc = [MyDocument]()
            var newListFolder = [MyFolder]()
            var needReload = false
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
                needReload = true
                
            }
            else {
                let result1 = zip(newListFolder, self!.listFolder).enumerated().filter() {
                    $1.0.getName() == $1.1.getName()
                }.map{$0.0}
                if result1.count == self?.listFolder.count { }
                else {
                    needReload = true
                    self?.listFolder = newListFolder
                }
                let result2 = zip(newListDoc, self!.listDocument).enumerated().filter() {
                    $1.0.getFileName() == $1.1.getFileName() && $1.0.isFavorite == $1.1.isFavorite
                }.map{$0.0}
                if result2.count == self?.listDocument.count { }
                else {
                    needReload = true
                    self?.listDocument = newListDoc
                }
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
            else {
                if (self?.activityIndicatorView.isAnimating ?? true) {
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.activityIndicatorView.stopAnimating()
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
    // </Load Data>
    
    // <Sort Data>
    private func changeSortMode(bool : [Bool]) {
        isSortByDate = bool[0]
        orderedAscending = bool[1]
        resortData()
        clvDocument.reloadSections(IndexSet(integer: 0))
    }
    private func resortData() {
        isSortByDate ? sortByDate() : sortByName()
        UserDefaults.standard.setValue([isSortByDate,orderedAscending], forKey: "SortMode")
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
    // </Sort Data>
    
    // <View as Grid/List>
    private func didTapListMode() {
        UserDefaults.standard.setValue(true, forKey: "isViewAsList")
        isViewAsList = true
        clvDocument.reloadData()
    }
    private func didTapGridMode() {
        UserDefaults.standard.setValue(false, forKey: "isViewAsList")
        isViewAsList = false
        clvDocument.reloadData()
    }
    // </View as Grid/List>
    
    // <Select Mode>
    private func gotoSelectMode() {
        navigationController?.navigationItem.title = "Select items"
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.vBottomTool.isHidden = false
            self?.clvBottomAnchor.constant = UIDevice.current.IS_169_RATIO() ? 40 : 60
//            self?.vToolBottomAnchor.constant = -40
            self?.isSelectMode = true
            self?.navigationItem.searchController = nil
            self?.navigationController?.navigationBar.prefersLargeTitles = false
            self?.view.layoutIfNeeded()
            self?.navigationController?.view.layoutIfNeeded()
            
        }
        removeNaviBarItem()
        addRightBarButtonWithTittle(title: "Done", action: #selector(tapDone))
        addLeftBarButtonWithTittle(title: "Select all", action: #selector(tapSelectAll))
        clvDocument.allowsMultipleSelection = true
    }
    private func comebackViewMode() {
        selectedCount = 0
        navigationItem.leftBarButtonItem = nil
        setupNavigation()
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.clvBottomAnchor.constant = UIDevice.current.IS_169_RATIO() ? -40 : 0
//            self?.vToolBottomAnchor.constant = -140
            self?.isSelectMode = false
            self?.view.layoutIfNeeded()
            self?.navigationController?.view.layoutIfNeeded()
        }
        vBottomTool.isHidden = true
        clvDocument.allowsMultipleSelection = false
    }
    // </Select Mode>
    
    // <Search>
    private func startSearch() {
        searchBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        UIView.animate(withDuration: 0.2) {[weak self] in
            self?.navigationController?.setNavigationBarHidden(true, animated: false)
            self?.topAnchorOfCollectionView.constant = 44
            self?.view.layoutIfNeeded()
        }
        searchBar.becomeFirstResponder()
    }
    private func stopSearch() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.isHidden = true
        topAnchorOfCollectionView.constant = 0
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.view.layoutIfNeeded()
        
    }
    // </Search>
    
    // <Document Aceess>
    private func actionDelete() {
        let alert = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
            if let selectedRows = self?.clvDocument.indexPathsForSelectedItems?.sorted(by: {$0 > $1}) {
                for indexPath in selectedRows  {
                    if indexPath.row < (self?.listFolder.count ?? 0) {
                        self?.removeFolder(indexPath: indexPath)
                    }
                    else {
                        self?.removeDocument(indexPath: indexPath)
                    }
                }
                self?.selectedCount = 0
                self?.isSelectAll = false
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    private func saveFavorite(indexPath : IndexPath) {
        let newDoc = listDocument[indexPath.item - listFolder.count]
        newDoc.isFavorite.toggle()
        RealmManager.shared.saveFavoritePDF(url: newDoc.getURL(), isFavorite: newDoc.isFavorite)
        listDocument[indexPath.item - listFolder.count] = newDoc
        guard let cell = clvDocument.cellForItem(at: indexPath) as? ListDocCollectionViewCell else {
            clvDocument.reloadItems(at: [indexPath])
            return
        }
        cell.isExpanding = false
        cell.isFavorite = newDoc.isFavorite
    }
    private func removeDocument(indexPath : IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            DispatchQueue.main.async {
                [weak self] in
                self?.listDocument.remove(at: indexPath.row - (self?.listFolder.count ?? 0))
                self?.clvDocument.deleteItems(at: [indexPath])
            }
            
            do {
                try FileManager.default.removeItem(at: (self?.listDocument[indexPath.row - (self?.listFolder.count ?? 0)].getURL())!)
            }
            catch {
                print("delete fail")
            }
        }
    }
        /// <Action for Folder>
    private func actionCreateFolder() {
        let alert = UIAlertController(title: "New Folder", message: "Please enter a new folder name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] action in
            
            if let name = alert.textFields?.first?.text {
                if name.isEmpty || name == "" {
                    self?.warningEmptyFolderName()
                }
                else {
                    self?.checkFolderName(name: name)
                }
            }
        }))
        alert.addTextField(configurationHandler: { textField in
            textField.becomeFirstResponder()
        })
        self.present(alert, animated: true)
    }
    private func checkFolderName(name : String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderPath = documentDirectory.appendingPathComponent(name)
        if FileManager.default.checkFileExists(url: folderPath) {
            let alert = UIAlertController(title: "Warning", message: "The folder already exists.\nPlease enter another name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self](action) in
                self?.actionCreateFolder()
            }))
            present(alert, animated: true, completion: nil)
        }
        else {
            createNewFolder(at: folderPath)
        }
    }
    private func warningEmptyFolderName() {
        let alert = UIAlertController(title: "Warning", message: "Please enter a new folder name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self](action) in
            self?.actionCreateFolder()
        }))
        present(alert, animated: true, completion: nil)
    }
    private func createNewFolder(at url : URL) {
        let newFolder = MyFolder(url: url)
        listFolder.insert(newFolder, at: 0)
        clvDocument.insertItems(at: [IndexPath(item: 0, section: 0)])
        do {
            try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription);
        }
    }
    private func removeFolder(indexPath : IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            DispatchQueue.main.async {
                [weak self] in
                self?.listFolder.remove(at: indexPath.row)
                self?.clvDocument.deleteItems(at: [indexPath])
            }
            
            do {
                try FileManager.default.removeItem(at: (self?.listFolder[indexPath.row].url)!)
            }
            catch {
                print("delete fail")
            }
        }
    }
        /// </Action for Folder>
    // </Document Access>
    
    // <Goto>
    private func openPDF(pdfData : Document) {
        let storyboard = UIStoryboard(name: "PDFDocument", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let pdfVC = navigationController.viewControllers.first as! PDFViewController
        pdfVC.config(with: pdfData)
        navigationController.modalTransitionStyle = .crossDissolve
        // Presenting modal in iOS 13 fullscreen
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    private func openBrowser() {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        picker.delegate = self
        present(picker, animated: true)
    }
    private func openInputVC () {
        let inputVC = InputVC(nibName: "InputVC", bundle: nil)
        inputVC.modalPresentationStyle = .overFullScreen
        present(inputVC, animated: false, completion: nil)
    }
    // </Goto>
    
    
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
                cell.delegate = self
                cell.setFolderData(folder: listFolder[indexPath.item], isSelectMode: isSelectMode)
            }
            else {
                cell.delegate = self
                cell.setDocuemtData(pdf: listDocument[indexPath.item - listFolder.count], isFavorite: listDocument[indexPath.item - listFolder.count].isFavorite , isSelectMode: isSelectMode)
            }
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridDocCollectionViewCell", for: indexPath) as? GridDocCollectionViewCell else {return UICollectionViewCell()}
            if indexPath.item < listFolder.count {
                cell.setFolderData(folder: listFolder[indexPath.item], isSelectMode: isSelectMode)
            }
            else {
                cell.setDocuemtData(pdf: listDocument[indexPath.item - listFolder.count], isFavorite: listDocument[indexPath.item - listFolder.count].isFavorite, isSelectMode: isSelectMode)
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
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
            self?.clvDocument.hideSwipeCell()
            viewAsList ? self?.didTapListMode() : self?.didTapGridMode()
        }
        header.didChangeSortMode = { [weak self] (bool) in
            self?.changeSortMode(bool: bool)
        }
        header.setupSortModeUI(sortMode: [isSortByDate,orderedAscending], isViewAsList: isViewAsList)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: isSelectMode ? 0 : 40)
    }
}
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
extension DocumentsVC : UIDocumentPickerDelegate, LaunchURLDelegate {
    func open(url: URL) {
        DispatchQueue.main.async { [weak self] in
            self?.openPDF(pdfData: Document(fileURL: url))
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FileManager.default.saveFile(from: url, at: self?.location) { [weak self] (done,urlSaved) in
                // :(
            }
        }
    }
    
    // UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let sourceURL = urls.first else { return }
        open(url: sourceURL)
    }
}

extension DocumentsVC : SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if isSelectMode { return nil }
        if indexPath.item < listFolder.count {
            if listFolder[indexPath.item].getName() == CMSConfigConstants.shared.defaultFolderName { return nil }
            guard orientation == .right else { return nil }
            // <Folder>
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
                let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
                    self?.removeFolder(indexPath: indexPath)
                }))
                self?.clvDocument.hideSwipeCell()
                self?.present(alert, animated: true, completion: nil)
            }
            
            deleteAction.image = UIImage(named: "ic_Delete-mini")
            deleteAction.backgroundColor = CMSConfigConstants.shared.themeStyle.backgroundGray
            deleteAction.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
            deleteAction.textColor = CMSConfigConstants.shared.themeStyle.tintGray
            
            return [deleteAction]
            //</Folder>
        }
        else { // <Document>
            guard orientation == .right else { return nil }
            let isFavor = listDocument[indexPath.item - listFolder.count].isFavorite
            
            // Favorite action
            let favorite = SwipeAction(style: .default, title: isFavor ? "Unfavorite" : "Favorite") { [weak self](action, indexPath) in
                self?.clvDocument.hideSwipeCell()
                self?.saveFavorite(indexPath: indexPath)
            }
            favorite.image = UIImage(named: isFavor ? "ic_Star-mini" : "ic_unStar-mini" )
            favorite.backgroundColor = CMSConfigConstants.shared.themeStyle.backgroundGray
            favorite.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
            favorite.textColor = CMSConfigConstants.shared.themeStyle.tintGray
            
            
            // Delete action
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
                let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
                    self?.removeDocument(indexPath: indexPath)
                }))
                self?.clvDocument.hideSwipeCell()
                self?.present(alert, animated: true, completion: nil)
            }
            deleteAction.image = UIImage(named: "ic_Delete-mini")
            deleteAction.backgroundColor = CMSConfigConstants.shared.themeStyle.backgroundGray
            deleteAction.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
            deleteAction.textColor = CMSConfigConstants.shared.themeStyle.tintGray
            
            
            // More action
            let moreAction = SwipeAction(style: .default, title: "More") {[weak self] action, indexPath in
                self?.clvDocument.hideSwipeCell()
            }
            moreAction.image = UIImage(named: "ic_More-mini")
            moreAction.backgroundColor = CMSConfigConstants.shared.themeStyle.backgroundGray
            moreAction.font = UIFont.getFontOpenSans(style: .SemiBold, size: 12)
            moreAction.textColor = CMSConfigConstants.shared.themeStyle.tintGray
            
            return [deleteAction,favorite,moreAction]
        } // </Document>
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .reveal
        options.backgroundColor = CMSConfigConstants.shared.themeStyle.backgroundGray
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
