
import Foundation

//Denne structen eksisterer statisk og bevarer lokasjonsdataene som skal hentes inn fra APIet.

struct LocationData {
    static var data: LocationData = LocationData()
    var lat: Float = 59.911166
    var lon: Float = 10.744810
    
    func setLocation(lat: Float, lon: Float) {
        LocationData.data.lat = lat
        LocationData.data.lon = lon
    }
}
