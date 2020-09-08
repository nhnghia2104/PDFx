//
//  ToolInputCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/8/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class ToolInputCell: UITableViewCell {
    var listTool : [Tool]?
    @IBOutlet weak var clvTool: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        clvTool.register(UINib(nibName: "ToolCell", bundle: nil), forCellWithReuseIdentifier: "ToolCell")
        clvTool.delegate = self
        clvTool.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(tools : [Tool]) {
        listTool = tools
    }
    
}
extension ToolInputCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTool?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolCell", for: indexPath) as? ToolCell else {return UICollectionViewCell()}
        cell.setData(tool: listTool?[indexPath.row] ?? Tool(name: "Nil", icon: nil))
        return cell
    }
    
    
}

extension ToolInputCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

