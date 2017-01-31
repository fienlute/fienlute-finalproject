//
//  DetailCell.swift
//  GOals
//
//  Created by Fien Lute on 30-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    
    // MARK: Outlets
    @IBOutlet weak var completedGoalLabel: UILabel!
    @IBOutlet weak var completedPointsLabel: UILabel!
    @IBOutlet weak var dateCompletedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
