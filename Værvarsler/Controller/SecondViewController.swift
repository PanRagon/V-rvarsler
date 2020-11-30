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



class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    let locationManager = CLLocationManager()
    let pin = MKPointAnnotation()
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var mapLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var containerVC: MapContainerViewController? = nil
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if(mapSwitch.isOn) {
            mapView.showsUserLocation = true
            mapView.removeAnnotation(pin)
            NotificationCenter.default.post(name: .didRecieveLocation, object: nil, userInfo: ["lat":Float(userLocation.latitude), "lon":Float(userLocation.longitude)])
        } else {
            mapView.showsUserLocation = false
            mapView.addAnnotation(pin)
            NotificationCenter.default.post(name: .didRecieveLocation, object: nil, userInfo: ["lat":Float(mapLocation.latitude), "lon":Float(mapLocation.longitude)])
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        //#selector aksesserer Objective-C objektet handleTap, som ikke er i Swift. Dette var i hvert fall den enkleste metoden jeg fant - https://stackoverflow.com/a/41111362
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended && !mapSwitch.isOn) {
            let location = sender.location(in: mapView)
            mapLocation = mapView.convert(location, toCoordinateFrom: mapView)
            pin.coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            NotificationCenter.default.post(name: .didRecieveLocation, object: nil, userInfo: ["lat":Float(mapLocation.latitude), "lon":Float(mapLocation.longitude)])
        }
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Denne løsningen for å oppdatere location til brukerens posisjon er tatt herifra: https://stackoverflow.com/a/25451592/14283546
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            LocationData.data.setLocation(lat: Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
            userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            NotificationCenter.default.post(name: .didRecieveLocation, object: nil, userInfo: ["lat":Float(location.coordinate.latitude), "lon":Float(location.coordinate.longitude)])
        }
    }
    
    
    
}

