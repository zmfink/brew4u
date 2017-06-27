//
//  mapPage.swift
//  Beer Manager
//
//  Created by Connor Coughlin on 3/31/17.
//  Copyright © 2017 Connor Coughlin. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class map_view: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 42.2808, longitude: -83.7430)
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self


        var artwork = Artwork(title: "Hopcat",
                              locationName: "Brewery",
                              discipline: "Brewery",
                              coordinate: CLLocationCoordinate2D(latitude: 42.2791, longitude: -83.7418))
        mapView.addAnnotation(artwork)
        
        artwork = Artwork(title: "Arbor Brewing Company",
                              locationName: "Brewery",
                              discipline: "Brewery",
                              coordinate: CLLocationCoordinate2D(latitude: 42.2803, longitude: -83.7478))
        mapView.addAnnotation(artwork)
        
        artwork = Artwork(title: "Jolly Pumpkin",
                              locationName: "Brewery",
                              discipline: "Brewery",
                              coordinate: CLLocationCoordinate2D(latitude: 42.2792, longitude: -83.7485))
        mapView.addAnnotation(artwork)

    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let artwork = Artwork(title: "Hopcat",
//                              locationName: "Brewery",
//                              discipline: "Brewery",
//                              coordinate: CLLocationCoordinate2D(latitude: 42.2791, longitude: -83.7418))
//        
//       mapView.addAnnotation(artwork)
//    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
