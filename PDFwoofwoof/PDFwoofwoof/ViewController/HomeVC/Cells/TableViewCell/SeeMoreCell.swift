//
//  SeeMoreCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 8/14/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class SeeMoreCell: BaseTableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setText(str : String) {
        self.lblTitle.text = str
    }
}
