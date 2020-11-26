//
//  WeatherModel.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 26/11/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let temperatureUnits: String
    let percipitationUnits: String
    
    let instantTemperature: Int
    
    let nextHourWeather: String
    let nextHourPercipitation: Int
    
    let next6HoursWeather: String
    let next6HoursPercipitation: Int
    
    let next12HoursWeather: String
    
    func getWeatherString(symbolCode: String) -> String {
        if let index = symbolCode.range(of: "_")?.lowerBound {
            let 
        }
    }
}
