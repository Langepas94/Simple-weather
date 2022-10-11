//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Артём Тюрморезов on 11.10.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation

struct NetworkWeatherManager {
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString)
            }
        }
        task.resume()
    }
}
