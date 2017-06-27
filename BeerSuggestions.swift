//
//  BeerSuggestions.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/4/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation
import UIKit

class BeerSuggestions : UIViewController {
    
    var myInformation:Int!
    override func viewDidLoad() {
        let url = URL(string: "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/beer/style/" + String(myInformation))
        
        let task = URLSession.shared.dataTask(with:url!) { data, response, error in
            if error != nil {
                print(error ?? "ERROR")
            } else {
                do {

                    let beersArray = try! (JSONSerialization.jsonObject(with: data!, options: [])) as! NSArray
                    print(type(of: beersArray))
                    
                    for beer in beersArray {
                        let tempBeer = beer as! Dictionary<String, Any>
                        print(type(of: tempBeer))
                        print(tempBeer["name"] ?? "Please add me to your linkedIn -BLAKE MCDONALD")
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
