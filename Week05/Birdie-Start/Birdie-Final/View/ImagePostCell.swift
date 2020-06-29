//
//  ImagePostCell.swift
//  Birdie-Final
//
//  Created by Ruslan on 29.06.2020.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ImagePostCell: UITableViewCell {

    static let identifier = "ImagePostCell"
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textbodyLabel: UILabel!
    @IBOutlet weak var bodyImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
