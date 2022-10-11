//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Артём Тюрморезов on 11.10.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation
import CoreLocation
class NetworkWeatherManager {
    enum RequestType {
        case cityName(city: String)
        case coodinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    var onCompletion: ((CurrentWeather) -> Void)?
    
//    func fetchCurrentWeather(forCity city: String) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
//        performRequest(with: urlString)
//    }
//    func fetchCurrentWeather(for latitude: CLLocationDegrees, longitede: CLLocationDegrees) {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitede)&apikey=\(apiKey)&units=metric"
//        performRequest(with: urlString)
//    }
    
    func fetchCurrentWeather(for requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
        case .coodinate(let latitude, let longitede):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitede)&apikey=\(apiKey)&units=metric"
        }
        performRequest(with: urlString)
    }
    
   fileprivate func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
          let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
