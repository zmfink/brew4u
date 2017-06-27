//
//  VCMapView.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 4/8/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation


import MapKit

extension map_view: MKMapViewDelegate {
    
    // 1
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                
                let button = UIButton(type: .detailDisclosure)
                
//                button.addTarget(self, action: #selector(map_view.showAnnotationDisclosure(sender: AnyObject.self as AnyObject)), for: .TouchUpInside)
                
                view.rightCalloutAccessoryView = button
                
                
                
            }
            return view
        }
        return nil
    }
    
    func showAnnotationDisclosure(sender: AnyObject) {
        print("Disclosure button clicked")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("HopCat Pressed!")
            performSegue(withIdentifier: "locationBeers", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationBeers" {
            var destination = segue.destination as! TableCellViewHolder
            destination.beer_query = String(1)
            destination.searched = false
            //destination.fbUserID = fbUserID
        }
    }
    

    
    
}
