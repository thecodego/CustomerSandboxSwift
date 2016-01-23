//
//  ViewController.swift
//  MapKit Practice
//
//  Created by Chih-Kai Liang on 1/15/16.
//  Copyright © 2016 Chih-Kai Liang. All rights reserved.
//

import UIKit
import MapKit
import Parse
import CoreLocation     // For locating current location

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()   // For locating current location
    
    let regionRadius: CLLocationDistance = 1000
    
    // Creating an instance of PFObject(Parse Object)
    let parseObject = PFObject(className: "LocationDetail")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()                // Authroize the app to use the location service
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        */
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // For setting up maps
        self.mapView.mapType = .Standard
        self.mapView.showsUserLocation = true
        
        // self.mapView.removeAnnotations(self.mapView.annotations)
        
        /*
        let location = self.locationManager.location
        
        var latitude: Double = location!.coordinate.latitude
        var longitude: Double = location!.coordinate.longitude
        
        print("current latitude :: \(latitude)")
        print("current longitude :: \(longitude)")
        */
        
        // Query from online database
        // queryTable()
        
        // Query from local database
        // queryLocalTable()
        
        
        /*
        // Set initial location in Honolulu
        // Latitude and longtitude is for center point
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        centerMapOnLocation(initialLocation)
        
        mapView.delegate = self
        */

        // Show artwork on map
        let artwork = Artwork(title: "Home", locationName: "Madison Park", discipline: "Home", coordinate: CLLocationCoordinate2D(latitude: 43.830019, longitude: -111.796710))
        
        mapView.addAnnotation(artwork)

    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        // setRegion tells mapView to display the region
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func queryTable() {
        
        var query = PFQuery(className: "LocationDetail")
        
        /*
        query.getObjectInBackgroundWithId("uVhuyRJMQI") {
            (locationDetail: PFObject?, error: NSError?) -> Void in
            if error == nil && locationDetail != nil {
                
                if let location = locationDetail {
                    // print(location)
                    
                    let tempTitle = location["Title"] as! String
                    let tempLocationName = location["locationName"] as! String
                    print("Title: \(tempTitle), tempLocation: \(tempLocationName)")
                    
                    
                }
                
            } else {
                print(error?.localizedDescription)
            }
            
        }
        */
        
        query.whereKey("discipline", equalTo: "Sculpture")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                // Successfully retrieve the data from the database
                print("\(objects!.count) objects found!")
                
                if let locations = objects {
                    
                    for location in locations {
                        print("Title: \(location["Title"])")
                    }
                }
            } else {
                print("Error retrieveing objects")
            }
            
            
        }
    }
    
    func queryLocalTable() {
        
        let query = PFQuery(className: "LocationDetail")
        query.fromLocalDatastore()
        query.getObjectInBackgroundWithId("TfIHDdYn6C") {
            
            (locationDetail: PFObject?, error: NSError?) -> Void in
            if error == nil && locationDetail != nil {
                if let location = locationDetail {
                    
                    let tempTitle = location["Title"] as! String
                    print("Title: \(tempTitle)")
                    
                }
            }
            
        }
        
    }
    
    func addNewData(title: String, locationName: String, discipline: String, latitude: Double, longtitude: Double) {
        
        parseObject["Title"] = title
        parseObject["locationName"] = locationName
        parseObject["discipline"] = discipline
        parseObject["latitude"] = latitude
        parseObject["longtitude"] = longtitude
        
        // Save to local database 
        parseObject.pinInBackground()
        
        // Save to network database
        parseObject.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            print("Location record has been saved")
        }
        
    }
    
    
    // MARK: Get current location (Location Delegate method)
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }


}

