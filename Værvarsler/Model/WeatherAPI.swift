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
protocol WeatherAPIDelegate {
    func didUpdateWeather(_ weatherAPI: WeatherAPI, weather: WeatherModel)
    func didFailToUpdate(_ error: Error?)
}
struct WeatherAPI {
    let apiUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact.json"
    
    var delegate: WeatherAPIDelegate?
    
    func fetchWeather(lat: Float, lon: Float) {
        let url = "\(apiUrl)?lat=\(lat)&lon=\(lon)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailToUpdate(error)
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let temperatureUnits = decodedData.properties.meta.units.airTemperatureUnit
            let precipitationUnits = decodedData.properties.meta.units.precipitationAmountUnit
            
            //I eksempelene på oppgaven vises temperatur og nedbør i hele tall, fra APIet kommer de som tall med ett desimalltall. Derfor runder jeg dem her til nærmeste heltall og caster til Int8, da vi ikke ønsker bevare desimaltallene og -128c til 127c uansett dekker hele spekteret av temperaturer på jordens overflate.
            //Merk: Dette kan føre til problemer dersom global oppvarming går av skaftet - dette har jeg ikke tatt høyde for.
            let instantTemperature = Int8(round(decodedData.properties.timeseries[1].data.instant.details.airTemperature))
            
            let nextHourCode = decodedData.properties.timeseries[1].data.nextHour!.summary.symbolCode
            let nextHourPrecipitation = Int8(round(decodedData.properties.timeseries[1].data.nextHour!.details!.precipitationAmount))
            
            let next6HoursCode = decodedData.properties.timeseries[1].data.next6Hours!.summary.symbolCode
            let next6HoursPrecipitation =  Int8(decodedData.properties.timeseries[1].data.next6Hours!.details!.precipitationAmount)
            
            let next12HoursCode = decodedData.properties.timeseries[1].data.next12Hours!.summary.symbolCode
            
            
            
            
            let weather = WeatherModel(temperatureUnits:temperatureUnits, precipitationUnits:precipitationUnits, instantTemperature:instantTemperature, nextHourCode:nextHourCode, nextHourPrecipitation: nextHourPrecipitation, next6HoursCode: next6HoursCode,  next6HoursPrecipitation: next6HoursPrecipitation, next12HoursCode:next12HoursCode)
            print(weather)
            return weather
        } catch {
            delegate?.didFailToUpdate(error)
            return nil
        }
    }
}
