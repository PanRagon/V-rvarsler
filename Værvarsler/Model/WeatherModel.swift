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
    let precipitationUnits: String
    
    let instantTemperature: Float
    
    let nextHourCode: String
    let nextHourPrecipitation: Float
    
    let next6HoursCode: String
    let next6HoursPrecipitation: Float
    
    let next12HoursCode: String
    
    
    func getWeatherString(symbolCode: String) -> String {
        //Hvis den ikke har med _night/_day i det hele tatt vil vi bare sende
        //symbolCode
        var weather = symbolCode
        if let index = symbolCode.range(of: "_")?.lowerBound {
            let sub = symbolCode[..<index]
            
            weather = String(sub)
        }
        
        switch weather {
        case "clearday":
            return "Sol"
        case "cloudy":
            return "Overskyet"
        case "fair":
            return "Lett overskyet"
        case "fog":
            return "Tåke"
        case "heavyrain":
            return "Kraftig Regn"
        case "heavyrainandthunder":
            return  "Kraftig Regn og Torden"
        case "heavyrainshowers":
            return "Kraftig Regnbyger"
        case "heavyrainshowersandthunder":
            return "Kraftig Regnbyger og Torden"
        case "heavysleet":
            return "Kraftig Sludd"
        case "heavysleetandthunder":
            return "Kraftig Sludd og Torden"
        case "heavysleetshowers":
            return "Kraftig Sluddbyger"
        case "heavysleetshowersandthunder":
            return "Kraftig Sluddbyger og Torden"
        case "heavysnow":
            return "Kraftig Snø"
        case "heavysnowshowers":
            return "Kraftig Snøbyger"
        case "heavysnowshowersandthunder":
            return "Kraftig Snøbyger og Torden"
        case "lightrain":
            return "Lett Regn"
        case "lightrainshowers":
            return "Lette Regnbyger"
            
        //Jeg bruker dette som "errorhandling" dersom vi får inn noe uventet
        //fra APIet. Det kan for eksempel tenke seg at met vil legge til nye
        //kategorier i framtiden. I dette tilfellet mener jeg det gir mer mening at
        //vi bare viser symbolcoden i appen enn en feilmelding som ikke gir brukeren
        //noe informasjon om været
        default:
            return weather
        }
    }
}
