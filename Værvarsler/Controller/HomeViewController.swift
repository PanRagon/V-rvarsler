

import Foundation
import CoreLocation
import UIKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, WeatherAPIDelegate {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var updatedLabel: UILabel!
    let dateFormatter = DateFormatter()
    let defaults = UserDefaults.standard
    var shouldSpin = true
    var currentWeather: String? = nil
    let locationManager = CLLocationManager()
    @IBOutlet var symbolImage: UIImageView!
    var weatherAPI = WeatherAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.locale = Locale(identifier: "nb")
        dateFormatter.dateFormat = "dd/MM yyyy HH:mm"
        self.locationManager.requestWhenInUseAuthorization()
        weatherAPI.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            Toast.show(message: "Vi trenger din lokasjon for å gi deg værinformasjon på ditt sted", controller: self)
        }
        
        if(self.defaults.string(forKey: "currentDay") != nil && self.defaults.string(forKey: "weather") != nil && self.defaults.string(forKey: "lastUpdated") != nil) {
            self.dayLabel.text = self.defaults.string(forKey: "currentDay")
            let storedWeather = self.defaults.string(forKey: "weather")
            let img = storedWeather == "Regn" ? "umbrella" : "sun.max"
            self.symbolImage.image = UIImage(named: img)
            let date = String(self.defaults.string(forKey: "lastUpdated")!)
            self.updatedLabel.text = "Sist oppdatert: \(date)"
            currentWeather = storedWeather
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        symbolImage.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func animations() {
        DispatchQueue.main.async {
            if(self.currentWeather == "Sol") {
                UIView.animate(withDuration: 5, animations: {
                    self.view.backgroundColor = UIColor.yellow
                })
                let slowRotate : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                slowRotate.toValue = NSNumber(value: Double.pi * 2)
                slowRotate.duration = 30
                slowRotate.isCumulative = true
                slowRotate.repeatCount = Float.infinity
                self.symbolImage.layer.add(slowRotate, forKey: "rotationAnimation")
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            if(shouldSpin) {
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = 0
                rotateAnimation.toValue = CGFloat(Double.pi * 2)
                rotateAnimation.duration = 3
                rotateAnimation.autoreverses = true
                symbolImage.layer.add(rotateAnimation, forKey: "360")
            } else {
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 1
                scaleAnimation.toValue = 3
                scaleAnimation.duration = 3
                scaleAnimation.autoreverses = true
                symbolImage.layer.add(scaleAnimation, forKey: "3")
            }
            shouldSpin = !shouldSpin
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Denne løsningen for å oppdatere location til brukerens posisjon er tatt herifra: https://stackoverflow.com/a/25451592/14283546
        if let location = locations.last{
            weatherAPI.fetchWeather(lat: Float(location.coordinate.latitude), lon: Float(location.coordinate.longitude))
        }
    }
    
    func didFailToUpdate(_ error: Error) {
        //Må kjøres i main-thread siden Toasten gjør endringer i layout engine.
        DispatchQueue.main.async {
            Toast.show(message: "Error: \(error.localizedDescription)", controller: self)
        }
        //Kjører animasjoner etter fetching er fullført.
        animations()
    }
    func didUpdateWeather(_ weatherAPI: WeatherAPI, weather: WeatherModel) {
        let nextHourSymbol = weather.getUmbrellaIcon(symbolCode: weather.nextHourCode)
        let next6HoursSymbol = weather.getUmbrellaIcon(symbolCode: weather.next6HoursCode)
        let next12HoursSymbol = weather.getUmbrellaIcon(symbolCode: weather.next12HoursCode)
        
        let day = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        let date = dateFormatter.string(from: Date())
        DispatchQueue.main.async {
            self.dayLabel.text = day.capitalized(with: nil)
            self.updatedLabel.text = "Sist oppdatert: \(date)"
            self.defaults.set(day.capitalized(with: nil), forKey: "currentDay")
            self.defaults.set(date, forKey: "lastUpdated")
            if(nextHourSymbol != "Regn" && next6HoursSymbol != "Regn" && next12HoursSymbol != "Regn") {
                self.symbolImage.image = UIImage(named: "sun")
                self.infoLabel.text = "Sol i dag, ingen paraply trengs!!"
                self.defaults.set("Sol", forKey: "weather")
                self.currentWeather = "Sol"
            } else {
                self.symbolImage.image = UIImage(named: "umbrella")
                self.infoLabel.text = "I dag blir det vått, ha paraplyen klar!"
                self.defaults.set("Regn", forKey: "weather")
                self.currentWeather = "Regn"
            }
        }
        //Kjører animasjoner etter fetching er fullført.
        animations()
    }
}
