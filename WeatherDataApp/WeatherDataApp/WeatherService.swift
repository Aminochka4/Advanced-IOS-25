//
//  WeatherService.swift
//  WeatherDataApp
//
//  Created by Амина Аманжолова on 08.04.2025.
//

import Foundation

class WeatherService {
    
    let api_key = ""
    // Current weather
    func fetchCurrentWeather(city: String) async throws -> CurrentWeather {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(api_key)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(CurrentWeather.self, from: data)
        return decoded
    }

    // 5-day forecast
    func fetchForecast(lat: Double, lon: Double) async throws -> [ForecastItem] {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(api_key)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
        return decoded.list
    }
    
    // UV Index
    func fetchUVIndex(lat: Double, lon: Double) async throws -> UVIndex {
        let urlString = "https://api.openweathermap.org/data/2.5/uvi?lat=\(lat)&lon=\(lon)&appid=\(api_key)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UVIndex.self, from: data)
    }
        
    // Air Quality
    func fetchAirQuality(lat: Double, lon: Double) async throws -> AirQuality {
        let urlString = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=\(api_key)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(AirQuality.self, from: data)
    }
}

