//
//  WeatherManger.swift
//  Clima
//
//  Created by MoKhaled on 16/03/2024.
//  Copyright © 2024 App Brewery. All rights reserved.

import Foundation
import CoreLocation

protocol WeatherMangerDelegate {
    func didUpdateWeather(weather :WeatherModel)
    func didFaidWeather (error:Error)
}


struct WeatherManger {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=7736125361641a23b08749a603d02a33&units=metric"
    var delegate: WeatherMangerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees,longitute:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString : String) {
        // 1. Create URL
        if  let url = URL(string: urlString) {
            // 2. Create URL Session
            let session = URLSession(configuration: .default)
            // 3. Give the  session a task (Data Task )
            
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    delegate?.didFaidWeather(error: error!)
                    return
                }
                if let safeData = data {
                    if  let weather =  self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
            
        }
    }
    
    func parseJSON( weatherData : Data ) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
            return weather
            
            
        }catch {
            delegate?.didFaidWeather(error: error)
            return nil
            
        }
    }
    
    
    
    
    
    
}

