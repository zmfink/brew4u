//
//  firstTimeQs.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 4/3/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit

class firstTimeQs : UIViewController {
    
    
    @IBOutlet weak var beerImage: UIImageView!
    
    @IBOutlet weak var beerName: UILabel!
    
    @IBOutlet weak var cosmosViewPreciseQs: CosmosView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    

    var sampleBeers:[BeerData] = []
    var currIndex = 0 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosViewPreciseQs.settings.fillMode = StarFillMode.full
        
        EZLoadingActivity.show("Loading...", disableUI: false)

        // get info about all sample beers
        var url_string = "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/beer/starter"
        
        var url = URL(string: url_string)
        var urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on url")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON
            do {
                
                guard let beersArray = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? NSArray else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                // let's just print it to prove we can access it
                print("The returnedJSON: " + beersArray.description)
                
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
                    
                    bd.beerID = beerDict["id"] as! String!
                    
                    var temp = beerDict["breweries"] as! NSArray
                    var temp2 = temp[0] as! NSDictionary
                    var temp3 = temp2["id"] as! String ?? "0"
                    bd.brewID = temp3
                    
                    bd.categoryID = beerDict["categoryId"] as! Int! ?? 0
                    bd.abv = beerDict["abv"] as! String!
                    bd.notes = beerDict["notes"] as! String! ?? "Places notes here"
                    print("notessss: " + String(bd.notes))
                    bd.beerDescription = beerDict["description"] as! String!
                    bd.breweryName = beerDict["name"] as! String!
                    
                    self.sampleBeers.append(bd)
                    
                }
                
                EZLoadingActivity.hide()

                
                DispatchQueue.main.async {

                    // add all beer details to page
                    self.beerName.text = self.sampleBeers[self.currIndex].beerName
                    
                    // get actual image
                    if self.sampleBeers[self.currIndex].beerPic != nil {
                        let tempbeerPic = self.sampleBeers[self.currIndex].beerPic 
                        let url = URL(string: tempbeerPic!)
                        let data = try? Data(contentsOf: url!)
                        self.beerImage.image = UIImage(data: data!)
                    }
                    
                }


            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        
        task.resume()

        print(cosmosViewPreciseQs.rating)
    }

    
    @IBAction func submitRating(_ sender: Any) {
        
        print(cosmosViewPreciseQs.rating)
        
        if cosmosViewPreciseQs.rating != 0.0 {
            
            
            let userID = fbUserID
            let json: [String: Any] = [
                "user_id": userID,
                "beer_id": sampleBeers[currIndex].beerID,
                "breweryId": sampleBeers[currIndex].brewID ?? "",
                "abv": sampleBeers[currIndex].abv ?? "",
                "categoryId": sampleBeers[currIndex].categoryID ?? "",
                "rating": Double(String(format: "%.1f", cosmosViewPreciseQs.rating)),
                "notes": "Place notes here"
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
            
            if currIndex + 1 < sampleBeers.count {
                // reset stars
                cosmosViewPreciseQs.rating = 0.0
                currIndex += 1
                changeInfo()
            } else {
                // go to home page
                performSegue(withIdentifier: "toHomeTwo", sender: nil)
            }
        }
        
    }
    
    
    @IBAction func skipBeer(_ sender: Any) {
        if currIndex + 1 < sampleBeers.count {
            // reset stars
            cosmosViewPreciseQs.rating = 0.0
            currIndex += 1
            changeInfo()
        } else {
            // go to home page
            performSegue(withIdentifier: "toHomeTwo", sender: nil)
        }
    }
    
    
    
    func changeInfo() {
        // add all beer details to page
        beerName.text = sampleBeers[currIndex].beerName
        
        // get actual image
        if sampleBeers[currIndex].beerPic != nil {
            let tempbeerPic = sampleBeers[currIndex].beerPic
            let url = URL(string: tempbeerPic!)
            let data = try? Data(contentsOf: url!)
            beerImage.image = UIImage(data: data!)
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueBeerTypeConnect" {
//            var destination = segue.destination as! TableCellViewHolder
//            destination.myInformation = categoryID
//            destination.beerType = beer_type
//            destination.searched = searched
//            //destination.fbUserID = fbUserID
//        }
    
//    func updateRating() {
//        let value = Double(ratingSlider.value)
//        rateScore = Double(String(format: "%.1f", value))
//        cosmosViewPrecise.rating = value
//        self.beerRating.text = String(format: "%.1f", value)
//    }
    
    
    func didTouchCosmos(_ rating: Double) {
        print("didTouchCosmos")
        print(cosmosViewPreciseQs.rating)

    }
    
    func didFinishTouchingCosmos(_ rating: Double) {
        print("didFinishTouchingCosmos")
        print(cosmosViewPreciseQs.rating)
    }


}
