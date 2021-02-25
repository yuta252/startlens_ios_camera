//
//  PictureCell.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/25.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {

    @IBOutlet weak var exhibitImageView: UIImageView!
    @IBOutlet weak var exhibitNameText: UILabel!
    @IBOutlet weak var exhibitDescriptionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
