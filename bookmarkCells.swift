//
//  bookmarkCells.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 4/8/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit

class bookmarkCell: UITableViewCell {
    @IBOutlet weak var beerNameLabel: UILabel!
    

    @IBOutlet weak var scoreLabel: UILabel!
    
    
    @IBOutlet weak var beerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization Code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
