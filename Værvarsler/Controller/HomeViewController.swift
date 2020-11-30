//
//  HomeViewController.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 29/11/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, WeatherAPIDelegate {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    let dateFormatter = DateFormatter()
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    @IBOutlet var symbolImage: UIImageView!
    var weatherAPI = WeatherAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.locale = Locale(identifier: "No")
        self.locationManager.requestWhenInUseAuthorization()
        weatherAPI.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            Toast.show(message: "Vi trenger din lokasjon for å gi deg værinformasjon", controller: self)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Denne løsningen for å oppdatere location til brukerens posisjon er tatt herifra: https://stackoverflow.com/a/25451592/14283546
        if let location = locations.last{
            weatherAPI.fetchWeather(lat: Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
        }
    }
    
    func didFailToUpdate(_ error: Error) {
        //Må kjøres i main-thread siden Toasten gjør endringer i layout engine.
        DispatchQueue.main.async {
            Toast.show(message: "Error: \(error.localizedDescription)", controller: self)
            self.dayLabel.text = self.defaults.string(forKey: "currentDay")
            let img = self.defaults.string(forKey: "weather") == "Regn" ? "umbrella" : "sun.max"
            self.symbolImage.image = UIImage(named: img)
        }
    }
    func didUpdateWeather(_ weatherAPI: WeatherAPI, weather: WeatherModel) {
        let nextHourSymbol = weather.getUmbrellaIcon(symbolCode: weather.nextHourCode)
        let next6HoursSymbol = weather.getUmbrellaIcon(symbolCode: weather.next6HoursCode)
        let next12HoursSymbol = weather.getUmbrellaIcon(symbolCode: weather.next12HoursCode)
        
        let day = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        print(day)
        DispatchQueue.main.async {
            self.dayLabel.text = day.capitalized(with: nil)
            self.defaults.set(day, forKey: "currentDay")
            if(nextHourSymbol != "Regn" && next6HoursSymbol != "Regn" && next12HoursSymbol != "Regn") {
                self.symbolImage.image = UIImage(named: "sun")
                self.infoLabel.text = "Sol i dag, ingen paraply trengs!!"
                self.defaults.set("Sol", forKey: "weather")
            } else {
                self.symbolImage.image = UIImage(named: "umbrella")
                self.infoLabel.text = "I dag blir det vått, ha paraplyen klar!"
                self.defaults.set("Regn", forKey: "weather")
            }
        }
        
    }
}
