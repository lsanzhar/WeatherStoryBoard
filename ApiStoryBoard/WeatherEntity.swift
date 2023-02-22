//
//  WeatherEntity.swift
//  ApiStoryBoard
//
//  Created by swift on 15.02.2023.
//

import Foundation




class WeatherEntitiy: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    class Main: Decodable {
        let temp: Double
        let feels_like: Double
    }
    class Wind: Decodable {
        let speed: Double
    }
    class Weather: Decodable {
        let id: Int
    }
    
}
