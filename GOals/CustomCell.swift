//
//  CustomCell.swift
//  
//
//  Created by Fien Lute on 13-01-17.
//
//

import UIKit

class CustomCell: UITableViewCell {

    
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



