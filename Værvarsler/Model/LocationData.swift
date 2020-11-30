//
//  LocationData.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 28/11/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import Foundation

//Denne structen eksisterer statisk og bevarer lokasjonsdataene som skal hentes inn fra APIet.
//Jeg kan instansiere den med lokasjonen til HK med en gang, det gjør at HK blir en "standard" lokasjon inntil ny data er hentet inn, som gjør at tableviewet alltid kan bruke denne dataen.
/*struct LocationData {
    static var data: LocationData = LocationData()

    
    func setLocation(lat: Float, lon: Float) {
        LocationData.data.lat = lat
        LocationData.data.lon = lon
    }
}
*/
