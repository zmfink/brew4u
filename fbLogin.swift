//
//  fbLogin.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/30/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit

import FBSDKLoginKit


class fbLogin : UIViewController, FBSDKLoginButtonDelegate {
  
    
    var fromLogout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fbUserID = FBSDKAccessToken.current().userID
//        print("User Id: " + fbUserID)
        if (FBSDKAccessToken.current() == nil || fromLogout) {

            let loginButton = FBSDKLoginButton()
            view.addSubview(loginButton)
            loginButton.center = self.view.center
            //loginButton.frame = CGRect(x: 16, y: 250, width: view.frame.width - 32, height: 50)
            loginButton.delegate = self
        } else {
            fbUserID = FBSDKAccessToken.current().userID
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && !fromLogout) {
            print("logged in")
            print("token: " + String(describing: FBSDKAccessToken.current().userID))
            performSegue(withIdentifier: "toHomePage", sender: nil)
            
        }
        fromLogout = false
    }



    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("logged out of FB")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print ("successful login with facebook")
        
        EZLoadingActivity.show("Authorizing...", disableUI: false)

        var usr_id:NSString!
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error != nil {
                    print(error)
                }
                
                print(result)
                print("printed result")
                usr_id = ((result! as AnyObject).value(forKey: "id")  as? NSString)!
                
                var url_string = "https://cfb78gu8a5.execute-api.us-east-1.amazonaws.com/Development/user/" + (usr_id as String)

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
                        guard let returnedJSON = try JSONSerialization.jsonObject(with: responseData, options: [])
                            as? [String: String] else {
                                print("error trying to convert data to JSON")
                                return
                        }
                        
                        // let's just print it to prove we can access it
                        print("The returnedJSON: " + returnedJSON.description)
                        
//                        guard let status = returnedJSON["status"] else {
//                            print("Could not get status from JSON")
//                            return
//                        }
                        status = returnedJSON["status"]
                        print("The status is: " + status)
                    
                        fbUserID = String(FBSDKAccessToken.current().userID)
                        
                        DispatchQueue.main.async { //After(deadline: DispatchTime.now() + delayInSeconds)
                            if status == "created" {
                                EZLoadingActivity.hide()
                                self.performSegue(withIdentifier: "toSampleBeers", sender: nil)
                            } else if status == "exists" {
                                EZLoadingActivity.hide()
                                self.performSegue(withIdentifier: "toHomePage", sender: nil)
                            }
                        }

                    } catch  {
                        print("error trying to convert data to JSON")
                        return
                    }
                }
                task.resume()
                
            })
            
        } // end of if((FBSDKAccessToken.current()) != nil){
        

        //if status == "created" {
         //   self.performSegue(withIdentifier: "toSampleBeers", sender: nil)
            
      //  } else if status == "exists" {
        
//        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            if status == "created" {
//                EZLoadingActivity.hide()
//                self.performSegue(withIdentifier: "toSampleBeers", sender: nil)
//            } else if status == "exists" {
//                EZLoadingActivity.hide()
//                self.performSegue(withIdentifier: "toHomePage", sender: nil)
//            }
//        }
        
      //  }
        
    } // end of login func
    
}

