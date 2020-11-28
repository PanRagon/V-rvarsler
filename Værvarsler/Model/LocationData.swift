//
//  LocationData.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 28/11/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import Foundation

protocol LocationDataDelegate {
    func didUpdateLocation()
}
struct LocationData {
    static var data: LocationData = LocationData()
    
    var lat: Float = 59.911166
    var lon: Float = 10.744810
    
    func setLocation(lat: Float, lon: Float) {
        this.lat = lat
        this.lon = lon
        delegate.didUpdateLocation()
    }
}
