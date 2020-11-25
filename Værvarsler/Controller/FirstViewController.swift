//
//  FirstViewController.swift
//  Værvarsler
//
//  Created by Kandidatnummer 10042 on 30/10/2020.
//  Copyright © 2020 Kandidatnummer 10042. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let weatherModel = WeatherModel();

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.fetchWeather(lat: 59.911166, lon: 10.744810)
    }


}

