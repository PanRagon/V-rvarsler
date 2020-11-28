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
    
    let instantTemperature: Int8
    
    let nextHourCode: String
    let nextHourPrecipitation: Int8
    
    let next6HoursCode: String
    let next6HoursPrecipitation: Int8
    
    let next12HoursCode: String
    
    
    func getWeatherString(symbolCode: String) -> String {
        var weather: String
        //Vi splitter arrayet på "_" og fjerner det som kommer etter, da detter er bare natt/dag som vi ikke skal bruke i appen uansett.
        //Koden tatt her basert på dette svaret fra StackOverflow: https://stackoverflow.com/a/39185097
        if let index = symbolCode.range(of: "_")?.lowerBound {
            let sub = symbolCode[..<index]
            
            weather = String(sub)
        } else {
            //Hvis den ikke har med _night/_day i det hele tatt vil vi bare sende
            //symbolCode
            weather = symbolCode
        }
        //Her er det ikke helt tydelig fra oppgaven om man bør oversette alle symbolene eller bare til "nærmeste" (f.eks. burde heavyrainshowersandthunder kanskje bare være 'Regn' eller 'Tung Regn'), men jeg har i hvert fall tolket det som at vi kan presentere hele spekteret av vær som kommer ut av APIet. Jeg oversetter derfor hvert symbol for seg selv, selv om dette er litt mer verbøst i denne delen.
        switch weather {
        case "clearday":
            return "Sol"
        case "cloudy":
            return "Overskyet"
        case "fair":
            return "Lett Overskyet"
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
        case "lightrainandthunder":
            return "Lett Regn og Torden"
        case "lightrainshowers":
            return "Lette Regnbyger"
        case "lightrainshowersandthunder":
            return "Lette Regnbyger og Torden"
        case "lightsleet":
            return "Lett Sludd"
        case "lightsleetandthunder":
            return "Lett Sludd og Torden"
        case "lightsleetshowers":
            return "Lette Sluddbyger"
        case "lightsnow":
            return "Lett Snø"
        case "lightsnowandthunder":
            return "Lett Snø og Torden"
        case "lightsnowshowers":
            return "Lett Snøbyger"
        case "lightssleetshowersandthunder":
            return "Lette Sluddbyger og Torden"
        case "lightssnowshowersandthunder":
            return "Lette Snøbyger og Torden"
        case "partlycloudy":
            return "Delvis Overskyet"
        case "rain":
            return "Regn"
        case "rainandthunder":
            return "Regn og Torden"
        case "rainshowers":
            return "Regnbyger"
        case "rainshowersandthunder":
            return "Regnbyger og Torden"
        case "sleet":
            return "Sludd"
        case "sleetandthunder":
            return "Sludd og Torden"
        case "sleetshowers":
            return "Sluddbyger"
        case "sleetshowersandthunder":
            return "Sluddbyger og Torden"
        case "snow":
            return "Snø"
        case "snowandthunder":
            return "Snø og Torden"
        case "snowshowers":
            return "Snøbyger"
        case "snowshowersandthunder":
            return "Snøbyger og Torden"
            
            
        //Jeg bruker dette som en "errorhandling" dersom vi får inn noe uventet
        //fra APIet. Det kan for eksempel tenke seg at met vil legge til nye eller endrer på
        //koder i framtiden. I dette tilfellet mener jeg det gir mer mening at
        //vi bare viser symbolcoden i appen enn en feilmelding som ikke gir brukeren
        //noe faktisk informasjon om været
        default:
            return weather
        }
    }
}
