//
//  VCMapView.swift
//  MapKit Practice
//
//  Created by Chih-Kai Liang on 1/15/16.
//  Copyright © 2016 Chih-Kai Liang. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    
    // 1 the method that gets called for every annotation you add to the map, to return the view for each annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                // 2 Map views are set up to reuse annotation views when some are no longer visible.
                // The code first checks to see if a reusable annotation view is available before creating a new one
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true  // The little bubble that pops up when the user taps on the pin
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            
            // view.pinColor = annotation.pinColor()
            
            return view
        }
        
        return nil
        
    }
    
    
    /*
     * When the user taps a map annotation pin, the callout shows an info button. If the user taps this info button,
     * the method is called
     */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // You grab the Artwork object that this tap refers to and then launch the Maps app by creating an associated MKMapItem
        // and calling openInMapsWithLaunchOptions on the map item
        let location = view.annotation as! Artwork
        
        // You're passing a dictionary to this method. This allows you to specify a few different options
        // Here the DirectionModeKeys is set to Driving. This will make the Mpas app try to show driving directions from the user's
        // current location to this pin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        // Use the mapItem method from Artwork class to get the MapItem and have Map app display it
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    
}