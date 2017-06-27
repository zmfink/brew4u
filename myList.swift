//
//  myList.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/19/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation
import UIKit

class myList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //UItableViewDataSource
    
    @IBOutlet weak var myListCell: UITableView!
    @IBOutlet weak var myCellBlank: myListCellBlank!
    
    var beerType:String!
    
    //var fbUserID:String!
    
    var searched:Bool!
    
    var ratingsDict = [0: [BeerData](), 1: [BeerData](), 2: [BeerData](), 3: [BeerData](), 4: [BeerData]()]
    
    var beerDataArray = [BeerData]()
    
    var fromBeerPage = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if fromBeerPage { // || needToRefreshMyList == false {
            for (key, value) in self.ratingsDict {
                self.ratingsDict[Int(key)]?.sort {$0.rating > $1.rating }
            }
//            for beer in beerDataArray {
//                print("Bookmark notes return: " + beer.notes)
//            }
            
        } else {
            EZLoadingActivity.show("Loading...", disableUI: false)
            
            var user_id = fbUserID //grab from login
            
            var url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/beer?uid=" + user_id!)
            
            //print(url)
            let task = URLSession.shared.dataTask(with:url!) { data, response, error in
                if error != nil {
                    print(error ?? "ERROR")
                } else {
                    do {
                        //self.beerDataArray = [BeerData]() // reset to empty array
                        let beersArray = try ((JSONSerialization.jsonObject(with: data!, options: [])) as! NSArray)

                        for beer in beersArray {
                            
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
                            
                            let scoreSection = min(Int(floor(bd.rating)), 4) // score of 5.0 goes in 4-5 star section
                            
                            //var bookmarked = beerDict["bookmark"] as! String!
                            self.ratingsDict[scoreSection]?.append(bd)

                            
//                            if bookmarked == "n" {
//                                self.ratingsDict[scoreSection]?.append(bd)
//                            } else {
//                                self.beerDataArray.append(bd);
//                                print(bd)
//                                print("Notes: " + bd.notes)
//                            }
                        }

                        for (key, value) in self.ratingsDict {
                            self.ratingsDict[Int(key)]?.sort {$0.rating > $1.rating }
                        }
                        
                        EZLoadingActivity.hide()

                        DispatchQueue.main.async { //After(deadline: DispatchTime.now() + delayInSeconds) {
                            self.myListCell.reloadData()
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            
            task.resume()
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(ratingsDict[4 - section]!.count, 1)
        //return beerDataArray.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        var numSections = 0
//        for i in 0...4 {
//            if (ratingsDict[i]?.count)! > 0 {
//                numSections += 1
//            }
//        }
//        return numSections
        return 5 // max rating of 5, min rating of 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(ratingsDict)
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! myListCell!
        
        
        var ready = false
        for i in 0...4 {
            if (ratingsDict[i]?.count)! > 0 {
                ready = true
            }
        }
        if !ready {
            return tableView.dequeueReusableCell(withIdentifier: "myCell2")!
        }
        
        // add border around cells
        cell?.layer.masksToBounds = true
        cell?.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 1.0 ).cgColor
        cell?.layer.borderWidth = 2.0
        
        if ratingsDict[4 - indexPath.section]?.count == 0 { // no beers in this rating group
            // add 'blank beer' cell
            return tableView.dequeueReusableCell(withIdentifier: "myCell2")!
        } else {
            cell?.beerHeader?.text = ratingsDict[4 - indexPath.section]?[indexPath.row].beerName
            let s = NSString(format: "%.1f", (ratingsDict[4 - indexPath.section]?[indexPath.row].rating)!)
            cell?.ratingScore?.text = s as String
        
        
            // change default beer pic if one exists
            if ratingsDict[4 - indexPath.section]?[indexPath.row].beerPic != nil {
                
                let url = URL(string: (ratingsDict[4 - indexPath.section]?[indexPath.row].beerPic)!)
                
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise     unwrap in a if let check / try-catch
                
                cell?.beerIcon.image = UIImage(data: data!)
            }
            return cell!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let secTitle = 4 - section
        return String(secTitle) + " - " + String(secTitle + 1) + " Stars"
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x:CGFloat(0),y:CGFloat(0),width:CGFloat(0),height:CGFloat(0)))
//        // Add a bottomBorder
//        let border = UIView(frame: CGRect(x:CGFloat(0),y:CGFloat(0),width:CGFloat(self.view.bounds.width),height:CGFloat(2)))
//        border.backgroundColor = UIColor( red: 0/255, green: 0/255, blue:0/255, alpha: 1.0 )
//        headerView.addSubview(border)
//        let secNum = 4 - section
//        let secTitle = String(secNum) + " - " + String(secNum + 1) + " Stars"
//        var secView = UILabel(frame: CGRect(x:CGFloat(0),y:CGFloat(0),width:CGFloat(self.view.bounds.width),height:CGFloat(25)))
//        secView.text = secTitle
//        headerView.addSubview(secView)
//        
//        return headerView
//    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBeerPage" {
            var destination = segue.destination as! BeerPage
            let indexPath = self.myListCell.indexPathForSelectedRow
            let sect = indexPath?.section ?? -1
            let rowNum = indexPath?.row ?? -1
            
            let beerID = ratingsDict[4 - sect]?[rowNum].beerID
            
            destination.beerID = beerID// Grab Beer Id given indexAt
            destination.rateScore = Double(ratingsDict[4 - sect]![rowNum].rating)
            destination.beerStyleName = beerType
            destination.searched = searched
            destination.myList = true
            destination.ratedBefore = "y"
            destination.brewID = ratingsDict[4 - sect]?[rowNum].brewID
            destination.abv = ratingsDict[4 - sect]?[rowNum].abv
            destination.beer_name = ratingsDict[4 - sect]?[rowNum].beerName
            destination.categoryID = ratingsDict[4 - sect]?[rowNum].categoryID
            destination.beer_description = ratingsDict[4 - sect]?[rowNum].beerDescription
            destination.brew_name = ratingsDict[4 - sect]?[rowNum].breweryName
            destination.labels = ratingsDict[4 - sect]?[rowNum].labels
            
            destination.fromBookmark = false
            destination.beerIsBookmarked = "n" /////DELETE
            // if ! nil
            
            destination.notes = ratingsDict[4 - sect]?[rowNum].notes
            
            // send entire myList beer array
            destination.beerDict = ratingsDict
            
            // also send bookmarked beers list
            destination.beerDataArray = beerDataArray  /////DELETE
            
            // send sectionNum and rowNum to know which beer in ratingsDict to change the info
            destination.sectionNum = sect
            destination.rowNum = rowNum
        }
        
        
        ///DELETE
//        if segue.identifier == "bookmarkSegue" {
//            var destination = segue.destination as! bookmarks
//            needToRefreshMyList = false
//            destination.beerDataArray = beerDataArray
//            destination.ratingsDict = ratingsDict
//        }
        
    }
    

    
}
