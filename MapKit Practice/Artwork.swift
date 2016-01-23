//
//  Artwork.swift
//  MapKit Practice
//
//  Created by Chih-Kai Liang on 1/15/16.
//  Copyright © 2016 Chih-Kai Liang. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class Artwork: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): self.subtitle as! AnyObject]
        
        
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDictionary)
        
        // Create an MKMapItem from an MKPlacemark
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = self.title
        
        // The Maps app is able to read this MKMapItem and display the right thing
        return mapItem
    }
    
    
}
