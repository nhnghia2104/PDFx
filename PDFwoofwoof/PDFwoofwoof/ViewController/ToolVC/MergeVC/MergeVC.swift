//
//  MergeVC.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/3/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class MergeVC: UIViewController {

    @IBOutlet weak var vToolHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var clvDocuments: UICollectionView!
    var listDocument = [MyDocument]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupLayout()
    }
    
    func setupLayout() {
        if UIDevice.current.IS_169_RATIO() { // is iphone X
            vToolHeightAnchor.constant = 70.0
        }
    }
    
    func setupCollectionView() {
        clvDocuments.register(UINib(nibName: "GridDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridDocCollectionViewCell")
    }
}
extension MergeVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDocument.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridDocCollectionViewCell", for: indexPath) as? GridDocCollectionViewCell else {return UICollectionViewCell()}

            cell.setDocuemtData(pdf: listDocument[indexPath.item], isFavorite: false, isSelectMode: true)
        return cell
    }
    

}
extension MergeVC : UICollectionViewDelegateFlowLayout {
    
}
