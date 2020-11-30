//
//  MapContainerViewController.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 28/11/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import Foundation
import UIKit


class MapContainerViewController: UIViewController, WeatherAPIDelegate {

    var lat: Float = LocationData.data.lat
    var lon: Float = LocationData.data.lon
    @IBOutlet var lonLabel: UILabel!
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var weatherSymbol: UIImageView!
    var weatherAPI = WeatherAPI();
    var weather: WeatherModel? = nil
    var symbol:String? = nil
    
    func didUpdateWeather(_ weatherAPI: WeatherAPI, weather: WeatherModel) {
        print("Got weather")
        let symbol = weather.getWeatherIcon(symbolCode: weather.nextHourCode)
        DispatchQueue.main.async {
            self.weatherSymbol.image = UIImage(named: symbol)
            self.latLabel.text = String(self.lat)
            self.lonLabel.text = String(self.lon)
        }
    }
    
    func didFailToUpdate(_ error: Error) {
        DispatchQueue.main.async {
            Toast.show(message: "Error: \(error.localizedDescription)", controller: self)
        }
    }
    
    @objc func didUpdateMapLocation(_ notification: Notification) {
        print(notification)
        guard let lat = notification.userInfo!["lat"] as? Float else {return}
        guard let lon = notification.userInfo!["lon"] as? Float else {return}
        print(lat)
        print(type(of: lon))
        if(self.lat != lat || self.lon != lon) {
            print("Update!")
            self.lat = lat
            self.lon = lon
            weatherAPI.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPI.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateMapLocation(_:)), name: .didRecieveLocation, object: nil)
        //Jeg starter med å laste inn været på lokasjonen i LocationData, som er brukerens lokasjon, eller HK om de ikke har akseptert lokasjonsdata.
        lat = LocationData.data.lat
        lon = LocationData.data.lon
        weatherAPI.fetchWeather(lat: LocationData.data.lat, lon: LocationData.data.lon)
        
        
    }
}

extension Notification.Name {
    static let didRecieveLocation = Notification.Name("didRecieveLocation")
}
