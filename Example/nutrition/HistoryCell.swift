//
//  HistoryCell.swift
//  nutrition_Example
//
//  Created by Macintosh on 02/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var mealId: UILabel!
    @IBOutlet weak var foodItems: UILabel!

    @IBOutlet weak var category: UILabel!

    @IBOutlet weak var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
