//
//  WeatherViewModel.swift
//  WeatherDataApp
//
//  Created by Амина Аманжолова on 08.04.2025.
//

import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var currentWeatherError: String?
    
    @Published var forecastItems: [ForecastItem] = []
    @Published var isLoadingForecast = false
    @Published var forecastError: String?
    
    @Published var uvIndex: UVIndex?
    @Published var uvIndexError: String?

    @Published var airQuality: AirQuality.AirQualityItem?
    @Published var airQualityError: String?

    private let service = WeatherService()
    
    func fetchAll(city: String, lat: Double, lon: Double) async {
        async let currentWeatherTask: () = loadCurrentWeather(city: city)
        async let forecastTask: () = loadForecast(lat: lat, lon: lon)
        async let uvIndex: () = loadUVIndex(lat: lat, lon: lon)
        async let airQuality: () = loadAirQuality(lat: lat, lon: lon)
        
        _ = await (currentWeatherTask, forecastTask, uvIndex, airQuality)
    }

    // Loading current weather
    func loadCurrentWeather(city: String) async {
        do {
            let weather = try await service.fetchCurrentWeather(city: city)
            self.currentWeather = weather
        } catch {
            self.currentWeatherError = "Failed to load current weather: \(error.localizedDescription)"
        }
    }
    
    // Loading 5-day forecast
    func loadForecast(lat: Double, lon: Double) async {
        isLoadingForecast = true
        forecastError = nil
        do {
            let forecastItems = try await service.fetchForecast(lat: lat, lon: lon)
            let groupedForecast = groupForecastByDay(forecastItems)
            
            let filteredForecast = groupedForecast.filter { forecastItem in
                let forecastDate = Date(timeIntervalSince1970: forecastItem.dt)
                return !Calendar.current.isDateInToday(forecastDate)
            }
            
            let sortedForecast = filteredForecast.sorted { $0.dt < $1.dt }
            self.forecastItems = sortedForecast
        } catch {
            forecastError = "Failed to load forecast: \(error.localizedDescription)"
        }
        isLoadingForecast = false
    }
    
    // Loading UV index
    func loadUVIndex(lat: Double, lon: Double) async {
        do {
            let uv = try await service.fetchUVIndex(lat: lat, lon: lon)
            self.uvIndex = uv
        } catch {
            self.uvIndexError = "Failed to load UV Index: \(error.localizedDescription)"
        }
    }

    // Loading air quality
    func loadAirQuality(lat: Double, lon: Double) async {
        do {
            let air = try await service.fetchAirQuality(lat: lat, lon: lon)
            self.airQuality = air.list.first
        } catch {
            self.airQualityError = "Failed to load Air Quality: \(error.localizedDescription)"
        }
    }

    // Sorting by date in 5-day forecast
    private func groupForecastByDay(_ forecastItems: [ForecastItem]) -> [ForecastItem] {
        var groupedForecast = [String: [ForecastItem]]()
        
        for item in forecastItems {
            let date = DateFormatter.localizedString(from: Date(timeIntervalSince1970: item.dt), dateStyle: .short, timeStyle: .none)
            if groupedForecast[date] == nil {
                groupedForecast[date] = []
            }
            groupedForecast[date]?.append(item)
        }
        
        var result = [ForecastItem]()
        
        for (_, items) in groupedForecast {
            let averageTemp = items.map { $0.main.temp }.reduce(0, +) / Double(items.count)
            let averageWindSpeed = items.map { $0.wind.speed }.reduce(0, +) / Double(items.count)
            let mostCommonCondition = getMostCommonCondition(from: items)
            
            let aggregatedItem = ForecastItem(
                dt: items.first?.dt ?? 0,
                main: .init(temp: averageTemp, humidity: items.first?.main.humidity ?? 0),
                weather: [.init(description: mostCommonCondition)],
                wind: .init(speed: averageWindSpeed)
            )
            
            result.append(aggregatedItem)
        }
        
        return result
    }

    // Getting common condition (because condions during the day are defferent and I created func to get only frequent)
    private func getMostCommonCondition(from items: [ForecastItem]) -> String {
        var conditionCount = [String: Int]()
        
        for item in items {
            guard let description = item.weather.first?.description else { continue }
            conditionCount[description, default: 0] += 1
        }
        
        return conditionCount.max(by: { $0.value < $1.value })?.key ?? "N/A"
    }
}
