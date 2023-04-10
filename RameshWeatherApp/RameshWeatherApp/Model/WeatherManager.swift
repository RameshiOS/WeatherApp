//
//  WeatherManager.swift
//  RameshWeatherApp
//
//  Created by Ramesh Guddala on 08/04/23.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    var delegate: WeatherManagerDelegate?

    private let apiKey = "f28f276eff731be98458435a1611560c"
    private let url = "https://api.openweathermap.org/data/2.5/weather?&appid"
    
    func fetchWeather(cityName: String){
        let weatherURL = "\(url)=\(apiKey)&q=\(cityName)&units=metric"
        performRequest(with: weatherURL)
    }
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let weatherURL = "\(url)=\(apiKey)&lat=\(lat)&lon=\(lon)&units=metric"
        performRequest(with: weatherURL)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create URL
        if let url = URL(string: urlString) {
            // 2. Create URL Session
            let session = URLSession(configuration: .default)
            // 3. Give the session a Task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
              
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weather = WeatherModel(sunRiseSeconds: TimeInterval(decodedData.sys.sunrise), sunSetSeconds: TimeInterval(decodedData.sys.sunset), description: decodedData.weather[0].description, cityName: decodedData.name, conditionID: decodedData
                .weather[0].id, icon: decodedData.weather[0].icon, temperature: decodedData.main.temp, humidity: decodedData.main.humidity, wind: decodedData.wind.speed)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
 
}
