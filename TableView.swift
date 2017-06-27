//
//  TableView.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/6/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var ShareButton: UIButton!
    
    var indexAt:Int!
    
    struct BeerData {
        var beerName : String!
        var beerPic : String!
        var rating : Int!
    }
    
    var beerDataArray = [BeerData]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerDataArray = [BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4), BeerData(beerName: "beer2", beerPic: "beerPic2", rating: 5),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4),BeerData(beerName: "beer1", beerPic: "beerPic", rating: 4)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        cell?.textLabel?.text = beerDataArray[indexPath.section].beerName
        
//        cell.button.tag = indexPath.row
//        
//        cell?.ShareButton
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return beerDataArray.count
    }
    
    
    
    
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return beerDataArray[section].beerName
//    }
}
