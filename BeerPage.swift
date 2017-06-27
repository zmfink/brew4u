//
//  BeerPage.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 2/12/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation
import UIKit

class BeerPage: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet weak var beerCompat: UILabel!
    @IBOutlet weak var beerPic: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var alcContent: UILabel!
    @IBOutlet weak var submitRating: UIButton!
    @IBOutlet weak var rateBeer: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var notesSection: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    

    var beerID:String!
    var beerStyleName:String!
    var searched:Bool!
    var myList:Bool!
    var rateScore:Double!
    var brewID:String!
    var categoryID:Int!
    var notes:String!
    
    var beer_name:String!
    var beer_description:String!
    var abv:String!
    var labels:Dictionary<String, Any>!
    
    // beerDict sent from myList
    var beerDict:Dictionary<Int, [BeerData]>!
    // section and row num sent from myList (maybe from search as well?)
    var sectionNum:Int!
    var rowNum:Int!
    
    
    //For bookmarking toggle
    var bookmarkBool = true
    
    //From search page, tell whether beer is bookmarked
    var beerIsBookmarked:String!
    
    // know came from bookmark page
    var fromBookmark:Bool!
    
    // keep in order to pass back when going back to myList page
    var beerDataArray = [BeerData]()
    
    var ratedBookmarkedBeer:Bool!
    
//    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint2: NSLayoutConstraint!
    @IBOutlet weak var brewery_name: UILabel!
    var brew_name: String!
    
    //To know if we should should compatibility score are 0-5 rating
    var ratedBefore:String!
    
    @IBOutlet weak var compatabilityLabel: UILabel!
    var oldRateScore:String! //In case user clicks "Cancel"
    //Slider set up
    
    @IBOutlet weak var cosmosViewPrecise: CosmosView!
    @IBOutlet weak var beerRating: UILabel!
    //@IBOutlet weak var ratingSlider: UISlider!
    let starRating:Float = 0.0
    
    @IBAction func rateBeer(_ sender: Any) {
//        ratingSlider.isHidden = false
//        cosmosViewPrecise.isHidden = true
//        submitRating.isHidden = false
//        rateBeer.isHidden = true
//        cancelButton.isHidden = false
//        oldRateScore = beerRating.text
//        
//        if beerRating.text == "N/A" {
//            beerRating.text = String(2.5)
//            rateScore = 2.5
//            cosmosViewPrecise.rating = 2.5
//        }
        
        if cosmosViewPrecise.rating != 0.0 {
            
            bookmarkButton.isHidden = true
            rateScore = cosmosViewPrecise.rating
            
            let userID = fbUserID
            let json: [String: Any] = [
                "user_id": userID,
                "beer_id": beerID,
                "breweryId": brewID ?? "",
                "abv": abv ?? "",
                "categoryId": categoryID ?? "",
                "rating": rateScore,
                "notes": notesSection.text,
                "bookmark": "n"
            ]

            print(json)
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/user/rate/")
            var request = URLRequest(url: url!)
            request.httpMethod = "PUT"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
            
            beerRating.text = String(format: "%.1f", cosmosViewPrecise.rating)
            
        }

        
    }
    
    @IBAction func backButtonPress(_ sender: Any) {
        if beerRating.text != "N/A" {
            print("not equal to N/A")
            submitRating(sender)
        }
        
        // user didn't rate beer, just hit back button after reading beer description
        
        if myList == true {
            performSegue(withIdentifier: "backMyList", sender: nil)
        } else if fromBookmark == true {
            performSegue(withIdentifier: "backBookmark", sender: nil)
        } else {
            performSegue(withIdentifier: "backButtonConnector", sender: nil)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosViewPrecise.settings.updateOnTouch = true
                
        // use to know whether to send a post request and update beerDataArray bookmarked beers
        ratedBookmarkedBeer = false
        
        //Shift notes up code
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        //cancelButton.isHidden = true
        cosmosViewPrecise.isHidden = false
        //submitRating.isHidden = true
        //ratingSlider.isHidden = true
        beerCompat.isHidden = true
        compatabilityLabel.isHidden = true
        bookmarkButton.isHidden = true
        //TODO: What is rate score default to? Need to know if they have rated beer
        
        //You know it has been rated
        if myList == true {
            beerRating.text = String(format: "%.1f", rateScore)
            cosmosViewPrecise.rating = Double(String(format: "%.1f", rateScore))!
            //ratingSlider.value = Float((String(format: "%.1f", rateScore)))!

        }
        
        //Check to set bookmarkButton to "Bookmark" or "Unbookmark"
        //Come from bookmarks page (just pass fromBookmark bool) or search page (pass beer's bookmark variable)
        
        if beerIsBookmarked  == "y" {
            bookmarkButton.setTitle("Unbookmark", for: .normal)
            bookmarkButton.isHidden = false

        }
        
        // Do any additional setup after loading the view, typically from a nib.
        notesSection!.layer.borderWidth = 1
        notesSection!.layer.borderColor = UIColor.black.cgColor
        notesSection.text = notes
        
        
        brewery_name.text = brew_name
        beerName.text = beer_name
        beerDescription.text = beer_description != nil ? beer_description : "No description available"
        
        if abv == "N/A" {
            alcContent.text = abv
        } else {
            alcContent.text = abv + " %"
        }
        
        if ratedBefore == "y" {
            bookmarkButton.isHidden = true
            compatabilityLabel.isHidden = true
            beerCompat.isHidden = true
            beerRating.text = String(format: "%.1f", rateScore)
            cosmosViewPrecise.rating = rateScore
            //ratingSlider.value = Float((String(format: "%.1f", rateScore)))!
        } else {
            compatabilityLabel.isHidden = false
            beerCompat.text = String(Int(rateScore)) + " %"
            beerCompat.isHidden = false
            //bookmarButton text is "Bookmark" by default
            bookmarkButton.isHidden = false

        }
        
        if labels != nil {
            let tempPic = (labels as! Dictionary<String, Any>)["medium"]
            if tempPic != nil {
                var tempbeerPic = tempPic as! String!
                let url = URL(string: tempbeerPic!)
                let data = try? Data(contentsOf: url!)
                beerPic.image = UIImage(data: data!)
            }
        }
        
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 250
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 250
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backButtonConnector" {
            var destination = segue.destination as! TableCellViewHolder
            
            if bookmarkButton.titleLabel?.text == "Unbookmark" {
                let userID = fbUserID
                let json: [String: Any] = [
                    "user_id": userID,
                    "beer_id": beerID,
                    "bookmark": bookmarkBool,
                    "notes": notesSection.text
                ]
                print(json)
                
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                // create post request
                let url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/user/save")
                var request = URLRequest(url: url!)
                request.httpMethod = "PUT"
                
                // insert json data to the request
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                }
                
                task.resume()
            }

            destination.beer_query = beerStyleName
            destination.searched = searched
        } else if segue.identifier == "backMyList" {
            var destination = segue.destination as! myList
            destination.searched = false
            destination.fromBeerPage = true
            //change info for section/row beer that was selected from myList page in ratingsDict
            print("sectionNum: " + String(sectionNum))
            print("rowNum: " + String(rowNum))
            print("destination: " + String(describing: destination.ratingsDict[4 - sectionNum]))
            // maybe send back the sectionNum and rowNum and notes and rating then change on load for myList pg
            
            beerDict[4 - sectionNum]?[rowNum].notes = notesSection.text
            
            print("typeOF:" + String(describing: type(of: beerDict[4 - sectionNum])))
            // send the new rating as well
            // change its info to different section if score changed sections
            if min(Int(floor((beerDict[4 - sectionNum]?[rowNum].rating)!)), 4) != min(Int(floor(rateScore)), 4) {
                print("changed sections")
                beerDict[4 - sectionNum]?[rowNum].rating = rateScore
                let numRowsInNewSection = beerDict[min(Int(floor(rateScore)), 4)]?.count
                print("numRowsInNewSection: " + String(describing: numRowsInNewSection))
                
                // add beerData to new section
//                beerDict[min(Int(floor(rateScore)), 4)]?[numRowsInNewSection!] = (beerDict[4 - sectionNum]?[rowNum])!
                beerDict[min(Int(floor(rateScore)), 4)]?.append((beerDict[4 - sectionNum]?[rowNum])!)

                // remove beerData from old section
                beerDict[4 - sectionNum]?.remove(at: rowNum)
                
                
            } else {
                beerDict[4 - sectionNum]?[rowNum].rating = rateScore
            }
            //destination.ratingsDict[4 - sectionNum]?[rowNum].notes = notesSection.text
            //destination.ratingsDict[4 - sectionNum]?[rowNum].rating = rateScore
            destination.ratingsDict = beerDict
            
            //destination.beerDataArray = beerDataArray

        } else if segue.identifier == "backBookmark" {
            var destination = segue.destination as! bookmarks
            destination.fromHomePage = false

            // if beer is still bookmarked (ie didn't rate or unbookmark) then need to change possibly changed info about the beer in the notes section
            if bookmarkButton.isHidden == false && bookmarkButton.titleLabel?.text == "Unbookmark"  {
                beerDataArray[rowNum].notes = notesSection.text
                
                let userID = fbUserID
                let json: [String: Any] = [
                    "user_id": userID,
                    "beer_id": beerID,
                    "bookmark": bookmarkBool,
                    "notes": notesSection.text
                ]
                print(json)
                
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                
                // create post request
                let url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/user/save")
                var request = URLRequest(url: url!)
                request.httpMethod = "PUT"
                
                // insert json data to the request
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                }
                
                task.resume()
            }
            
            destination.beerDataArray = beerDataArray
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelRating(_ sender: Any) {
        //cancelButton.isHidden = true
        cosmosViewPrecise.isHidden = false
        rateBeer.isHidden = false
        //submitRating.isHidden = true
        //ratingSlider.isHidden = true
        if oldRateScore == "N/A" {
            cosmosViewPrecise.rating = 0.0
            rateScore = 0.0
            //ratingSlider.value = 2.5
        } else {
            cosmosViewPrecise.rating = Double(oldRateScore)!
            rateScore = Double(oldRateScore)!
            //ratingSlider.value = Float(oldRateScore)!
        }

        beerRating.text = oldRateScore
    }
    
    @IBAction func submitRating(_ sender: Any) {
        bookmarkButton.isHidden = true
        cosmosViewPrecise.isHidden = false
        //cancelButton.isHidden = true
        rateBeer.isHidden = false
        //submitRating.isHidden = true
        //ratingSlider.isHidden = true
        if rateScore != nil {
            beerRating.text = String(format: "%.1f", rateScore)
        }
        oldRateScore = beerRating.text
        
        ratedBookmarkedBeer = true
        
        let userID = fbUserID
        //let postString = "id=13&name=Jack" //change
        print("notes section: " + String(notesSection.text))
        let json: [String: Any] = [
            "user_id": userID,
            "beer_id": beerID,
            "breweryId": brewID ?? "",
            "abv": abv ?? "",
            "categoryId": categoryID ?? "",
            "rating": rateScore,
            "notes": notesSection.text,
            "bookmark": "n"
        ]
        
        print(json)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/user/rate/")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
        
        if fromBookmark == true {
            // delete newly rated beer from beerDataArray of bookmarked beers
            var index = 0
            for beer in beerDataArray {
                print("1 :" + beer.beerID + " 2: " + beerID)
                print("Index: " + String(index))
                if beer.beerID == beerID {
                    beerDataArray.remove(at: index)
                    break
                }
                
                index += 1
            }
        }
    
        
        
    }
    
//    @IBAction func onSliderChanged(_ sender: Any) {
//        updateRating()
//    }
//    
//    func updateRating() {
//        let value = Double(ratingSlider.value)
//        rateScore = Double(String(format: "%.1f", value))
//        cosmosViewPrecise.rating = value
//        self.beerRating.text = String(format: "%.1f", value)
//    }
    
//    func didTouchCosmos(_ rating: Double) {
//        //ratingSlider.value = Float(rating)
//        print("HEEERRRREE")
//        print(rating)
//        cosmosViewPrecise.rating = rating
//        rateScore = Double(String(format: "%.1f", rating))
//        beerRating.text = String(format: "%.1f", rating)
//    }
//    
//    func didFinishTouchingCosmos(_ rating: Double) {
//        //ratingSlider.value = Float(rating)
//        print("HEEERRRREE22222")
//        print(rating)
//        cosmosViewPrecise.rating = rating
//        rateScore = Double(String(format: "%.1f", rating))
//        self.beerRating.text = String(format: "%.1f", rating)
//    }
    
    @IBAction func bookmarkBeer(_ sender: Any) {
        
        if bookmarkButton.titleLabel?.text == "Bookmark" {
            bookmarkBool = true
            bookmarkButton.setTitle( "Unbookmark" , for: .normal )
            
            // if from bookmark page, then need to add it to list of bookmarked beers
            if fromBookmark == true {
                
                var bd = BeerData()
                
                bd.beerName = beer_name
                bd.labels = labels
                
                // try to grab the image if the beer has one
                let tempLabel = labels
                if tempLabel != nil {
                    let tempPic = tempLabel?["medium"]
                    if tempPic != nil {
                        bd.beerPic = tempPic as! String!
                    }
                }
                
                bd.beerID = beerID
                bd.rating = rateScore // shouldn't be anything.... TODO
                print("rating" + String(bd.rating))
                
//                var brewArray = beerDict["breweries"] as! NSArray
//                var singleBreweryDict = brewArray[0] as! NSDictionary
//                var brewID = singleBreweryDict["id"] as! String ?? "0"
                bd.brewID = brewID
                
                bd.categoryID = categoryID
                bd.abv = abv ?? "N/A"
                bd.notes = notesSection.text ?? "Places notes here"
                print("notessss: " + String(bd.notes))
                bd.beerDescription = beer_description
                bd.breweryName = brew_name
                
                beerDataArray.append(bd)
            }
            
        } else {
            bookmarkBool = false
            bookmarkButton.setTitle( "Bookmark" , for: .normal )
            
            //if unbookmarked, then need to remove it from the array if came from bookmark page
            if fromBookmark == true {
                var index = 0
                for beer in beerDataArray {
                    if beer.beerID == beerID {
                        beerDataArray.remove(at: index)
                        break
                    }

                    index += 1
                }
            }
            
        }
        
        //Send all information necessary for bookmark to API
        let userID = fbUserID
        let json: [String: Any] = [
            "user_id": userID,
            "beer_id": beerID,
            "bookmark": bookmarkBool,
            "notes": notesSection.text
        ]
        print(json)

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        
        // create post request
        let url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/user/save")
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()

    }
}

