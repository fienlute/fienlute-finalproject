//
//  GoalsCell.swift
//  GOals
//
//  Created by Fien Lute on 16-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit

class GoalsCell: UITableViewCell {

    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var addedByLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

