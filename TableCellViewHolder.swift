//
//  TableCellViewHolder.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/7/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation
import UIKit

class TableCellViewHolder: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var beer_query:String!
    
    var searched:Bool!
    
    var nothingReturned:Bool!
    
    //var fbUserID:String!


    struct BeerData {
        var beerName : String!
        var beerPic : String!
        var beerID : String!
        var rating : Double!
        var ratedBefore: String!
        var beerDescription:String!
        var alcCont:String!
        var labels:Dictionary<String, Any>!
        var notes:String!
        var breweryName:String!
        var catID: Int!
        var brewID: String!
        var bookmarked: String!
    }
    
    var beerDataArray = [BeerData]()
    
    
    //Check whether to see if beer is bookmarked or not
    var beerIsBookmarked:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EZLoadingActivity.show("Loading...", disableUI: false)
        
        nothingReturned = false
        
        
        var url = URL(string: "")///beer/search?q={query string}&uid={user_id} Working
        var userId = fbUserID
        
        if searched == true { // came from home page and searched for beer
            var query = beer_query + "&uid=" + userId!
            query = query.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/beer/search?q=" + query)
        } else { // came from mapView
            var query = beer_query + "?uid=" + userId!
            query = query.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/beer/location/" + query)
        }
        
        print(url)
        let task = URLSession.shared.dataTask(with:url!) { data, response, error in
            if error != nil {
                print(error ?? "ERROR")
            } else {
                do {

                    let beersArray = try (JSONSerialization.jsonObject(with: data!, options: [])) as! NSArray
                    //print(type(of: beersArray))
                    
                    if beersArray.count == 0 {
                        self.nothingReturned = true
                    }

                    for beer in beersArray {

                        let beerDict = beer as! Dictionary<String, Any>

                        var bd = BeerData()
                        bd.beerName = beerDict["name"] as! String!
                        
                        // try to grab the image if the beer has one
                        let tempLabel = beerDict["labels"]
                        if tempLabel != nil {
                            let tempPic = (tempLabel as! Dictionary<String, Any>)["medium"]
                            if tempPic != nil {
                                bd.beerPic = tempPic as! String!
                            }
                        }
                        

                        print(beerDict)
                        bd.beerID = beerDict["id"] as! String!
                        
                        bd.ratedBefore = beerDict["rating"] as! String!
                        bd.rating = beerDict["score"] as! Double!
                        bd.beerDescription = beerDict["description"] as! String!
                        bd.alcCont = beerDict["abv"] as! String! ?? "N/A"
                        bd.labels = beerDict["labels"] as! Dictionary<String, Any>!
                        bd.notes = beerDict["notes"] as! String! ?? "Place notes here"
                        bd.catID = beerDict["categoryId"] as! Int! ?? 0
                        
                        if let brewArrayTemp = beerDict["breweries"] {
                            var brewArray = brewArrayTemp as! NSArray
                            var singleBreweryDict = brewArray[0] as! NSDictionary
                            var brewID = singleBreweryDict["id"] as! String ?? "0"
                            bd.brewID = brewID
                            bd.breweryName = singleBreweryDict["name"] as! String!
                        } else {
                            bd.brewID = "N/A"
                            bd.breweryName = "N/A"
                        }
                        
                        bd.bookmarked = beerDict["bookmark"] as! String

                        print(beerDict["name"] ?? "Please add me to your linkedIn -BLAKE MCDONALD")
                        
                        self.beerDataArray.append(bd)
                    }
                    
                    
                    if !self.searched {
                        self.beerDataArray.sort { $0.rating > $1.rating }
                    }
                    
                    EZLoadingActivity.hide()
                    
                    DispatchQueue.main.async { //After(deadline: DispatchTime.now() + delayInSeconds) {
                        self.tableView.reloadData()
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerDataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell!
        
        
//        // get a global concurrent queue
//        let queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
//        // submit a task to the queue for background execution
//        dispatch_async(queue) {
//            let enhancedImage = self.applyImageFilter(image) // expensive operation taking a few seconds
//            // update UI on the main queue
//            dispatch_async(dispatch_get_main_queue()) {
//                self.imageView.image = enhancedImage
//                UIView.animateWithDuration(0.3, animations: {
//                    self.imageView.alpha = 1
//                }) { completed in
//                    // add code to happen next here
//                }
//            }
//        }
        
        // change default beer pic if one exists
        
        cell?.layer.masksToBounds = true
        cell?.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 1.0 ).cgColor
        cell?.layer.borderWidth = 2.0
        
        
        if beerDataArray[indexPath.row].beerPic != nil {
            
            let url = URL(string: beerDataArray[indexPath.row].beerPic)
            
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            cell?.beerIconCell.image = UIImage(data: data!)
        }
        
        cell?.titleLabel?.text = beerDataArray[indexPath.row].beerName
        
        if beerDataArray[indexPath.row].ratedBefore == "y" {
            cell?.compOrRatingLabel?.text = "Rating: "
            cell?.compLabel?.text = String(format: "%.1f", beerDataArray[indexPath.row].rating)
            cell?.backgroundColor = UIColor (red: 0, green: 180 / 255.0, blue: 20 / 255.0, alpha: 0.45)

        } else {
            cell?.compOrRatingLabel?.text = "Compatability: "
            cell?.compLabel?.text = String(Int(beerDataArray[indexPath.row].rating)) + " %"
        }
        
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if nothingReturned == true {
            return "No Beers Found"
        }
        return "Searched " + beer_query //IPA
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerPage" {
            var destination = segue.destination as! BeerPage
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let rowNum = indexPath?.row ?? -1
            
            let beerID = beerDataArray[rowNum].beerID
            destination.beerID = beerID// Grab Beer Id given indexAt
            destination.beerStyleName = beer_query
            destination.searched = searched
            destination.rateScore = beerDataArray[rowNum].rating
            destination.ratedBefore = beerDataArray[rowNum].ratedBefore
            destination.myList = false
            destination.beer_name = beerDataArray[rowNum].beerName
            destination.beer_description = beerDataArray[rowNum].beerDescription
            destination.abv = beerDataArray[rowNum].alcCont
            destination.labels = beerDataArray[rowNum].labels
            destination.notes = beerDataArray[rowNum].notes
            destination.brew_name = beerDataArray[rowNum].breweryName
            destination.categoryID = beerDataArray[rowNum].catID
            destination.brewID = beerDataArray[rowNum].brewID
            destination.fromBookmark = false
            destination.beerIsBookmarked = beerDataArray[rowNum].bookmarked
            print(rowNum)
        }
    }

}

