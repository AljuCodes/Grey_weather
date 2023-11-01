//
//  WeatherManager.swift
//  Grey Weather
//
//  Created by FAO on 25/10/23.
//

import Foundation
import CoreLocation


class WeatherManager {
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> WeatherResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Apikeys.weather)&units=metric") else { fatalError("Missing URL") }
        return try await getCurrentWeatherWithURL(url: url)
    }
    
    func getCurrentWeatherWithURL(url: URL)async throws -> WeatherResponse {
        let urlRequest = URLRequest(url: url)
        let (data, response ) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("network call did not go well")}
        let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
        print(decodedData)
        return decodedData
    }
}

struct Apikeys {
    static let weather = "ee3c2557e725dc3c07db0982d2a56f3d"
}

