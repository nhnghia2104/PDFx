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
        Tool(name: "Open File", icon: UIImage(named: "ic_Tool")!),
        Tool(name: "Fill & Sign", icon: UIImage(named: "ic_Tool")!),
        Tool(name: "Scan", icon: UIImage(named: "ic_Tool")!,type: .scan),
        Tool(name: "Create PDF", icon: UIImage(named: "ic_Tool")!),
        Tool(name: "Arrange Page", icon: UIImage(named: "ic_Tool")!),
        Tool(name: "Protect PDF", icon: UIImage(named: "ic_Tool")!),
        Tool(name: "Split PDF", icon: UIImage(named: "ic_Tool")!),
        Tool(name: "Merge PDFs", icon: UIImage(named: "ic_Tool")!, type: .merge),
        Tool(name: "Extract Page", icon: UIImage(named: "ic_Tool")!),
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.addRightBarButtonWithTittle(title: "Done", action: #selector(tapBack))
        setupBaseNavigation()
    }
    
    private func register() {
        clcTool.register(UINib(nibName: "ToolCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ToolCollectionViewCell")
    }
    
    private func setupCollectionView() {
//        self.clcTool.decelerationRate = UIScrollView.DecelerationRate.normal
        clcTool.contentInset.bottom = clcTool.contentInset.bottom + 40.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ( clcTool.frame.width - 60 ) / 2 , height: (( clcTool.frame.width - 80 ) / 3) * ( 1 / 1 ))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing =  20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
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
    
    private func goToMerge() {
        let mergeVC = UIStoryboard(name: "Tool", bundle: nil).instantiateViewController(withIdentifier: "MergeVC") as! MergeVC
        
        self.navigationController?.pushViewController(mergeVC, animated: true)
    }
    private func presentCamera() {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        scannerViewController.modalPresentationStyle = .fullScreen
        scannerViewController.modalTransitionStyle = .crossDissolve
        present(scannerViewController, animated: true)
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
        let width = ( clcTool.frame.width - 60 ) / 2
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
        switch listTools[indexPath.row].type {
        case .merge:
            goToMerge()
            break
        case .scan:
            presentCamera()
            break
        case .none:
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}

extension ToolVC : ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
}
