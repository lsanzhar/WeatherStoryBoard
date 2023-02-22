//
//  ViewController.swift
//  ApiStoryBoard
//
//  Created by swift on 15.02.2023.
//

import UIKit
import CoreLocation
import Alamofire

// add delegate
class WeatherViewController: UIViewController, CLLocationManagerDelegate, GetWeatherViewControllerDelegate {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var FellsResult: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    
    let weather: [String] = ["cloudy","rain","storm","sun","wind"]
    
    
    public let WEATHER_URL: String = "https://api.openweathermap.org/data/2.5/weather"
    public let API_KEY: String = "8b9f776f695b68ae7da0bef7865b0554"
    
    public var temperature: Double = 0
    public var fells: Double = 0
    public var speed: Double = 0
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // чтобы все эти функии работали обязательно слова "delegate"
        locationManager.delegate = self
        
        // чтобы считать расстояние в метрах
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        //чтобы рабтало при регистраций
        locationManager.requestWhenInUseAuthorization()
        // местоположение
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        cityNameLabel.text = "Местоположение не найдено"
    }
    
    // локация
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("location: \(location)")
            let params: [String: Any] = ["lat": location.coordinate.latitude,
                                         "lon": location.coordinate.longitude,
                                         "appid": API_KEY,
                                         "units": "metric"]
            
            getWeatherData(url: WEATHER_URL, params: params)
        }
        
    }
// взять определенные данные в WeatherEntity
    func getWeatherData(url: String, params: [String: Any]) {
        AF.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success( _ ):
                do {
                    if let responseData = response.data {
                        print(response)
                        let json = try JSONDecoder().decode(WeatherEntitiy.self, from: responseData)
                        self.temperature = json.main.temp
                        self.fells = json.main.feels_like
                        self.speed = json.wind.speed
                        self.updateUI(json: json)
                    } else {
                        print("Ошибка")
                    }
                } catch {
                    print(error)
                    self.cityNameLabel.text = "город не найден"
                }
            case .failure(let error):
                print(error)
                self.cityNameLabel.text = "Ошибка загрузки"
            }
            }
    }
    func updateUI(json: WeatherEntitiy) {
        temperatureLabel.text = "\(Int(json.main.temp)) °C"
        weatherConditionImageView.image = UIImage(named: updateWeatherIcon(condition: json.weather.first?.id ?? -1))
        cityNameLabel.text = json.name
        FellsResult.text = "\(Double(json.main.feels_like)) °C"
        windSpeed.text = "\(speed) km/h"
    }
    func updateWeatherIcon(condition: Int) -> String {
        switch condition {
        case 0...500:
            return "rain.png"
        case 800, 904:
            return "sun.png"
        case 800...804:
            return "cloudy.png"
        case 772...799, 900...903, 905...1000:
            return "storm.png"
            
        default:
            return "Не знаю"
            
        }

    }
    
    
    func getWeatherForCity(with name: String) {
        let params: [String: Any] = ["q": name, "appid": API_KEY, "units": "metric"]
        getWeatherData(url: WEATHER_URL, params: params)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city" {
            if let destination = segue.destination as? GetWeatherViewController {
                destination.delegate = self
            }
        }
    }
    
    @IBAction func getweatherinf(_ sender: UISwitch) {
        if sender.isOn == true {
            let temp = (temperature * 1.8000 + 32)
            let fellTemp = (Double(fells * 1.8000 + 32))
            
            temperatureLabel.text = "\(Int(temp)) F"
            FellsResult.text = "\(Double(fellTemp)) F"
        }else {
            temperatureLabel.text = "\(Int(temperature)) °C"
            FellsResult.text = "\(Double(fells)) °C"
            
        }
        
    }
}


