//
//  FirstViewController.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 30/10/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let weatherAPI = WeatherAPI();

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPI.fetchWeather(lat: 59.911166, lon: 10.744810)
    }


}

