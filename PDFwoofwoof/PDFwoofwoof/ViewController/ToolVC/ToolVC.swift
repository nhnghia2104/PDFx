//
//  ToolVC.swift
//  PDFwoofwoof
//
//  Created by Minh on 8/28/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class ToolVC: UIViewController {
    
    
    @IBOutlet weak var clcTool: UICollectionView!
    
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
    
    // MARK: - override function
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setupCollectionView()
        setupNavigation()
    }
    
    
    // MARK: - setup functions
    private func setupNavigation() {
        
        self.navigationItem.title = "Tool"
        self.addRightBarButtonWithTittle(title: "Done", action: #selector(tapBack))
        setupBaseNavigation()
    }
    
    private func register() {
        clcTool.register(UINib(nibName: "ToolCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ToolCollectionViewCell")
    }
    
    private func setupCollectionView() {
        self.clcTool.decelerationRate = UIScrollView.DecelerationRate.normal
        clcTool.contentInset.bottom = clcTool.contentInset.bottom + 40.0

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ( clcTool.frame.width - 80 ) / 3 , height: (( clcTool.frame.width - 80 ) / 3) * ( 1 / 1 ))
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing =  20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        clcTool.collectionViewLayout = layout
        
    }
    
    
    // MARK: - @objc function
    @objc func tapBack() {
        goToHome()
    }
    
    //MARK: - Action Function
    private func goToHome() {
        self.dismiss(animated: true, completion: nil)
    }

}



extension ToolVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolCollectionViewCell", for: indexPath) as? ToolCollectionViewCell else {return UICollectionViewCell()}
        
        cell.setData(tool: listTools[indexPath.row])
        return cell
    }
    
}


extension ToolVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( clcTool.frame.width - 80 ) / 3
        return CGSize(width: width , height: width * ( 1 / 1 ))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}
