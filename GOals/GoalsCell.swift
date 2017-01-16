//
//  GoalsCell.swift
//  GOals
//
//  Created by Fien Lute on 16-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit

class GoalsCell: UITableViewCell {

    @IBOutlet weak var labelGoal: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

