//
//  myListCells.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/20/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit

class myListCell: UITableViewCell {
    
    
    @IBOutlet weak var beerIcon: UIImageView!
    @IBOutlet weak var beerHeader: UILabel!
    @IBOutlet weak var ratingScore: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization Code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    
}
