//
//  WeatherModel.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 25/11/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import Foundation

//Oppsettet under er basert på Section 13 fra Angela Yu sitt
//Udemy kurs. Referert til i README
struct WeatherAPI {
    let apiUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact.json"
    
    func fetchWeather(lat: Float, lon: Float) {
        let url = "\(apiUrl)?lat=\(lat)&lon=\(lon)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData)
        } catch {
            print(error)
        }
    }
}
