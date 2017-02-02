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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
