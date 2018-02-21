//
//  WeatherView.swift
//  QuickWeather
//
//  Created by Joey Scarim on 2/17/18.
//  Copyright © 2018 Joey Scarim. All rights reserved.
//

import Cocoa

class WeatherView: NSView {

    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var cityTextField: NSTextField!
    
    @IBOutlet weak var currentConditionsTextField: NSTextField!
    
    func update(_ weather: Weather) {
        // do UI updates on the main thread
        DispatchQueue.main.async {
            self.cityTextField.stringValue = weather.city
            self.currentConditionsTextField.stringValue = "\(Int(weather.currentTemp))°F and \(weather.conditions)"
        }
    }
}
