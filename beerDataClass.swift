//
//  beerDataClass.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/30/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation


var fbUserID:String!

var status:String!

// if go from myList to bookmark page, and then back to myList, no need to refresh
var needToRefreshMyList:Bool!


class BeerData {
    var beerName : String!
    var beerPic : String!
    var beerID : String!
    var rating : Double!
    var brewID : String!
    var categoryID : Int!
    var abv : String!
    var notes : String!
    var beerDescription : String!
    var breweryName : String!
    var labels:Dictionary<String, Any>!
}
