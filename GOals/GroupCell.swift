//
//  GroupCell.swift
//  GOals
//
//  Created by Fien Lute on 19-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var newChannelNameField: UITextField!
    @IBOutlet weak var createChannelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
