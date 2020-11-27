//
//  TableViewFoodCell.swift
//  Macro-Tracker
//
//  Created by Sherwin on 11/25/20.
//  Copyright © 2020 Sherwin. All rights reserved.
//

import UIKit

class TableViewFoodCell: UITableViewCell {

    @IBOutlet var foodName: UILabel!
    @IBOutlet var calorieLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var carbLabel: UILabel!
    @IBOutlet var fatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
