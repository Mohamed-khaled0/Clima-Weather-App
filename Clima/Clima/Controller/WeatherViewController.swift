//
//  WeatherModel.swift
//  Clima
//
//  Created by MoKhaled on 15/03/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManger.requestLocation()
    }
    
    var weatherManger = WeatherManger()
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        
        locationManger.requestLocation()
        
        weatherManger.delegate = self
        searchTextField.delegate = self
        
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController:UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Your City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  let city =  searchTextField.text {
            weatherManger.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherMangerDelegate

extension WeatherViewController:WeatherMangerDelegate{
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.tempratureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFaidWeather(error: any Error) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.latitude
            weatherManger.fetchWeather(latitude: lat, longitute: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
