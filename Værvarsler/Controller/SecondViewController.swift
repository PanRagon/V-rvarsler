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

class SecondViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, WeatherAPIDelegate {

    var weatherAPI = WeatherAPI();
    let locationManager = CLLocationManager()
    let pin = MKPointAnnotation()
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if(mapSwitch.isOn) {
            mapView.showsUserLocation = true
            mapView.removeAnnotation(pin)
        } else {
            mapView.showsUserLocation = false
            mapView.addAnnotation(pin)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        locationManager.startUpdatingLocation()
        
        //#selector aksesserer Objective-C objektet handleTap, som ikke er i Swift. Dette var i hvert fall den enkleste metoden jeg fant - https://stackoverflow.com/a/41111362
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended && !mapSwitch.isOn) {
            let location = sender.location(in: mapView)
            print(location.x)
            let myCoordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
            pin.coordinate = myCoordinate
        }
    }
    
    func didUpdateWeather(_ weatherAPI: WeatherAPI, weather: WeatherModel) {
        
    }
    
    func didFailToUpdate(_ error: Error) {
        //Må kjøres i main-thread siden Toasten gjør endringer i layout engine.
        DispatchQueue.main.async {
            Toast.show(message: "Error: \(error.localizedDescription)", controller: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Denne løsningen for å oppdatere location til brukerens posisjon er tatt herifra: https://stackoverflow.com/a/25451592/14283546
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            LocationData.data.setLocation(lat: Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
            pin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(LocationData.data.lat), longitude: CLLocationDegrees(LocationData.data.lon))
        }
    }
    
}
