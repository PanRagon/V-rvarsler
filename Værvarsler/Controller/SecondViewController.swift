//
//  SecondViewController.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 30/10/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello, World!")
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let initialLocation = CLLocation(latitude: 59.911166, longitude:10.744810)
        
        mapView.centerToLocation(initialLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("location = \(locValue.latitude) \(locValue.longitude)")
        
    }
    
    


}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
