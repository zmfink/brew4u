//
//  UITableViewCell.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/7/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var beerIconCell: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var compLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var compOrRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization Code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
