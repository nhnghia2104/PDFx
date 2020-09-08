//
//  InputCell.swift
//  PDFwoofwoof
//
//  Created by Nghia NH on 9/8/20.
//  Copyright © 2020 WereSheep. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    private var type : TypeTool = .none
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgIcon.tintColor = CMSConfigConstants.shared.themeStyle.tintGray
        lblName.textColor = CMSConfigConstants.shared.themeStyle.tintGray
        lblName.font = UIFont.getFontOpenSans(style: .SemiBold, size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(tool : Tool) {
        lblName.text = tool.name
        imgIcon.image = tool.icon
        type = tool.type
    }
    
    func getType() -> TypeTool {
        return self.type
    }
    
}
