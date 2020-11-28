//
//  FirstViewController.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 30/10/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var precipitationLabel: UILabel!
}




class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WeatherAPIDelegate, LocationDataDelegate {
    
    var weatherAPI = WeatherAPI();
    var cells: [CellContent] = [CellContent(name:"H",description: "h", content:"h", precipitation:nil)]
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var weather: WeatherModel? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        weatherAPI.delegate = self
        weatherAPI.fetchWeather(lat:LocationData.data.lat, lon:LocationData.data.lon)
        renderedLocation.lat = LocationData.data.lat
        renderedLocation.lon = LocationData.data.lon
        if(LocationData.data.lat == 59.911166 && LocationData.data.lon == 10.744810) {
            locationLabel.text = "Høyskolen Kristiania"
        }
    }
    
    
    
    
    
    func didUpdateWeather(_ weatherAPI: WeatherAPI, weather: WeatherModel) {
        self.weather = weather
        cells = []
        let temperature = String(weather.instantTemperature) + " " + weather.temperatureUnits
        let instant = CellContent(name:"Nå", description:"Temperatur", content:temperature, precipitation:nil)
        cells.append(instant)
        
        let nextHourWeather = weather.getWeatherString(symbolCode: weather.nextHourCode)
        let nextHourPrecipitation = String(weather.nextHourPrecipitation) + " " + weather.precipitationUnits
        let nextHour = CellContent(name:"Neste time", description:"Vær", content:nextHourWeather, precipitation: nextHourPrecipitation)
        cells.append(nextHour)
        
        let next6HoursWeather = weather.getWeatherString(symbolCode: weather.next6HoursCode)
        let next6HoursPrecipitation = String(weather.nextHourPrecipitation) + " " + weather.precipitationUnits
        let next6Hours = CellContent(name:"Neste 6 timer", description: "Vær", content:next6HoursWeather, precipitation: next6HoursPrecipitation)
        cells.append(next6Hours)
        
        let next12HoursWeather = weather.getWeatherString(symbolCode: weather.next12HoursCode)
        let next12Hours = CellContent(name:"Neste 12 timer", description: "Vær", content:next12HoursWeather, precipitation:nil)
        cells.append(next12Hours)
        
        print(cells)
        DispatchQueue.main.async { self.tableView.reloadData()}
        
    }
    
    func didFailToUpdate(_ error: Error?) {
        print(error)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        //IndexPath gir et array med to tall hovr det andre tallet er den faktiske posisjonen i arrayet, jeg bruker indexPath[1] for å aksessere denne
        cell.timeLabel.text = cells[indexPath[1]].name
        cell.descriptionLabel.text = cells[indexPath[1]].description
        cell.typeLabel.text = cells[indexPath[1]].content
        cell.precipitationLabel.text = cells[indexPath[1]].precipitation
        return cell
    }



}


struct CellContent {
    let name: String
    let description: String
    let content: String
    let precipitation: String?
    
}
