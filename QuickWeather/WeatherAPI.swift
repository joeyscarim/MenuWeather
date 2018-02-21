//
//  WeatherAPI.swift
//  QuickWeather
//
//  Created by Joey Scarim on 2/15/18.
//  Copyright © 2018 Joey Scarim. All rights reserved.
//

import Foundation

struct Weather: CustomStringConvertible {
    var city: String
    var currentTemp: Float
    var conditions: String
    
    var description: String {
        return "\(city): \(currentTemp)F and \(conditions)"
    }
}

class WeatherAPI {
    let API_KEY = "7ede80781a1a6cba12bba87ae7bdc9d9"
    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
//    http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID={APIKEY}

  
    
    func fetchWeather(_ query: String, success: @escaping (Weather) -> Void) {

        let session = URLSession.shared
        // url-escape the query string we're passed
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: "\(BASE_URL)?APPID=\(API_KEY)&units=imperial&q=\(escapedQuery!)")

        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                NSLog("weather api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data!) {
                        success(weather)
                    }
                case 401: // unauthorized
                    NSLog("weather api returned an 'unauthorized' response. Did you set your API key?")
                default:
                    NSLog("weather api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        
        
        
        
        task.resume()
    }
    
    func weatherFromJSONData(_ data: Data) -> Weather? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var mainDict = json["main"] as! JSONDict
        var weatherList = json["weather"] as! [JSONDict]
        var weatherDict = weatherList[0]
        
        let weather = Weather(
            city: json["name"] as! String,
            currentTemp: mainDict["temp"] as! Float,
            conditions: weatherDict["main"] as! String
//            icon: weatherDict["icon"] as! String
        )
        
        return weather
    }
}
