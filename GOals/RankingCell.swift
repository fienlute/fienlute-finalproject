//
//  RankingCell.swift
//  GOals
//
//  Created by Fien Lute on 24-01-17.
//  Copyright © 2017 Fien Lute. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {

    @IBOutlet weak var userRankingLabel: UILabel!
    
    @IBOutlet weak var userPointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
