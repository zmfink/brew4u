//
//  bookmarks.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 4/8/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit

class bookmarks: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var beerDataArray = [BeerData]()
    var fromHomePage:Bool!
    
//    var ratingsDict = [0: [BeerData](), 1: [BeerData](), 2: [BeerData](), 3: [BeerData](), 4: [BeerData]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EZLoadingActivity.show("Loading...", disableUI: false)
        
        
        if fromHomePage == true {
            var user_id = fbUserID //grab from login
            var url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/beer/saved?uid=" + user_id!)

            let task = URLSession.shared.dataTask(with:url!) { data, response, error in
                if error != nil {
                    print("error")
                    print(error ?? "ERROR")
                } else {
                    do {
                        //self.beerDataArray = [BeerData]() // reset to empty array
                        let beersArray = try ((JSONSerialization.jsonObject(with: data!, options: [])) as! NSArray)

    //                    print ("got beers bookmarked")
    //                    print(beersArray)
                        for beer in beersArray {
                            print ("more than one bookmarked")
                            let beerDict = beer as! Dictionary<String, Any>
                            
                            var bd = BeerData()
                            bd.beerName = beerDict["name"] as! String! ?? "N/A"
                            bd.labels = beerDict["labels"] as! Dictionary<String, Any>!
                            // try to grab the image if the beer has one
                            let tempLabel = beerDict["labels"]
                            if tempLabel != nil {
                                let tempPic = (tempLabel as! Dictionary<String, Any>)["medium"]
                                if tempPic != nil {
                                    bd.beerPic = tempPic as! String!
                                }
                            }
                            
                            bd.beerID = beerDict["id"] as! String!
                            bd.rating = beerDict["score"] as! Double!
                            
                            var brewArray = beerDict["breweries"] as! NSArray
                            var singleBreweryDict = brewArray[0] as! NSDictionary
                            var brewID = singleBreweryDict["id"] as! String ?? "0"
                            bd.brewID = brewID
                            
                            bd.categoryID = beerDict["categoryId"] as! Int! ?? 0
                            bd.abv = beerDict["abv"] as! String! ?? "N/A"
                            bd.notes = beerDict["notes"] as! String! ?? "Places notes here"
                            bd.beerDescription = beerDict["description"] as! String!
                            bd.breweryName = singleBreweryDict["name"] as! String!
                            
                        
                            self.beerDataArray.append(bd)
                            
                        }
                        EZLoadingActivity.hide()
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            
            task.resume()
        } else {
            EZLoadingActivity.hide()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "HomeFromBookmark", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerDataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveCell") as! bookmarkCell!
        
        // change default beer pic if one exists
        
        cell?.layer.masksToBounds = true
        cell?.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 1.0 ).cgColor
        cell?.layer.borderWidth = 2.0
        
        
        if beerDataArray[indexPath.row].beerPic != nil {
            
            let url = URL(string: beerDataArray[indexPath.row].beerPic)
            
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            if data != nil {
                cell?.beerImage.image = UIImage(data: data!)
            }
        }
        
        cell?.beerNameLabel?.text = beerDataArray[indexPath.row].beerName
        cell?.scoreLabel?.text = String(Int(beerDataArray[indexPath.row].rating)) + " %"
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numBookmarked = beerDataArray.count as NSNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        var numString = formatter.string(from: numBookmarked)
        
        if numString == nil { // in case formatter doesn't work
            numString = String(describing: numBookmarked)
        }
        print(numString ?? "default")
        var finalNumString = numString?.capitalized
        
        if beerDataArray.count == 0 {
            return "No Bookmarked Beers"
        } else if beerDataArray.count == 1 {
            return finalNumString! + " Bookmarked Beer"
        } else {
            return finalNumString! + " Bookmarked Beers"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerPageFromBookmark" {
            //DELETE
            needToRefreshMyList = true // bc something might change on beerPage (rate beer, unbookmark)
            
            var destination = segue.destination as! BeerPage
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let rowNum = indexPath?.row ?? -1
            
            let beerID = beerDataArray[rowNum].beerID
            destination.beerID = beerID// Grab Beer Id given indexAt
            
            //This shouldnt exist in this scenario
            //destination.beerStyleName = beer_query
            
            destination.searched = false
            destination.rateScore = beerDataArray[rowNum].rating
            destination.ratedBefore = "n"
            destination.myList = false
            destination.fromBookmark = true
            destination.beerIsBookmarked = "y"
            destination.beer_name = beerDataArray[rowNum].beerName
            destination.beer_description = beerDataArray[rowNum].beerDescription
            destination.abv = beerDataArray[rowNum].abv
            destination.labels = beerDataArray[rowNum].labels
            
            print("Notes leaving bookmarks page: " + beerDataArray[rowNum].notes)
            destination.notes = beerDataArray[rowNum].notes
            destination.brew_name = beerDataArray[rowNum].breweryName
            destination.categoryID = beerDataArray[rowNum].categoryID
            destination.brewID = beerDataArray[rowNum].brewID
            destination.rowNum = rowNum
            
            destination.beerDataArray = beerDataArray
            print(beerDataArray.count)
            
        }
//        else if segue.identifier == "backMyListBookmark" {
//            var destination = segue.destination as! myList
//            destination.beerDataArray = beerDataArray
//            // if went to beerPage and then came back, needToRefreshMyList will be true, so this ratingsDict will be disregarded as it could have changed
//            destination.ratingsDict = ratingsDict
//        }
    }
    
}
