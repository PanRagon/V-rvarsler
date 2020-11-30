//
//  LocationData.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 28/11/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import Foundation

//Denne structen eksisterer statisk og bevarer lokasjonsdataene som skal hentes inn fra APIet.
//Et annet alternativ ville vært å ha structen instansiert inni KartViewet også hatt delegates for de andre viewene, men jeg testet fram med denne framgangsmåten fordi dataene skulle være globalt tilgjengelig for alle.
struct LocationData {
    static var data: LocationData = LocationData()
    var lat: Float = 59.911166
    var lon: Float = 10.744810
    
    func setLocation(lat: Float, lon: Float) {
        LocationData.data.lat = lat
        LocationData.data.lon = lon
    }
}
