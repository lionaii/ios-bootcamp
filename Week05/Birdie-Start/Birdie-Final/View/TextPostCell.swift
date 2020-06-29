//
//  TextPostCell.swift
//  Birdie-Final
//
//  Created by Ruslan on 29.06.2020.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class TextPostCell: UITableViewCell {

    static let identifier = "TextPostCell"
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textbodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
