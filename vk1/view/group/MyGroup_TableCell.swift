//
//  GroupTableCell.swift
//  vk1
//
//  Created by Igor Ivanov on 16/09/2019.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class MyGroup_TableCell: UITableViewCell {

    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
