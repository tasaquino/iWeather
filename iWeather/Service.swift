//
//  Service.swift
//  iWeather
//
//  Created by Thais Aquino on 11/11/2023.
//

import Foundation

struct City {
    let lat: String
    let lon: String
    let name: String
}

class Service {
    private let baseURL: String = "https://api.openweathermap.org/data/3.0/onecall"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func fetchData(city: City, _ completion: @escaping (ForecastResponse?) -> Void) {
        let urlString = "\(baseURL)?lat=\(city.lat)&lon=\(city.lon)&appid=\(Secrets.apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data else {
                completion(nil)
                return
            }
            
            do {
                let result = try self?.decoder.decode(ForecastResponse.self, from: data)
                completion(result)
            } catch {
                completion(nil)
                print(error)
            }
            
        }
        
        task.resume()
    }
}

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
    let current: Forecast
    let hourly: [Forecast]
    let daily: [DailyForecast]
}

// MARK: - Forecast
struct Forecast: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, temp, humidity
        case windSpeed = "wind_speed"
        case weather
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - DailyForecast
struct DailyForecast: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
