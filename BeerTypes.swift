//
//  SecondViewController.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 2/12/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation
import UIKit



class BeerTypes: UIViewController, UISearchBarDelegate {

    var categoryID = 1 // 30 for IPA for now
    var beer_query = ""
    var searched = false
    
    // FB userID sent from login page
    //var fbUserID:String!
    
    @IBOutlet weak var searchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()
        needToRefreshMyList = true

    
        searchBar.delegate = self
        beer_query = ""
        
        //Shift notes up code
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Search bar functionality
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        beer_query = searchBar.text!
        searched = true
        performSegue(withIdentifier: "segueBeerTypeConnect", sender: nil)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBeerTypeConnect" {
            var destination = segue.destination as! TableCellViewHolder
            destination.beer_query = beer_query
            destination.searched = searched
        }
        
        if segue.identifier == "showBookmarks" {
            var destination = segue.destination as! bookmarks
            destination.fromHomePage = true
        }
        
        if segue.identifier == "logoutSegue" {
            var destination = segue.destination as! fbLogin
            destination.fromLogout = true

        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 100
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

