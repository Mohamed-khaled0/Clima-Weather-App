//
//  WeatherData.swift
//  Clima
//
//  Created by MoKhaled on 17/03/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData:Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main:Codable {
    let temp:Double
}


struct Weather:Codable {
    let id:Int
    let main: String
    let description:String
    let icon : String
}
