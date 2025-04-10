//
//  WeatherModel.swift
//  WeatherDataApp
//
//  Created by Амина Аманжолова on 08.04.2025.
//

import Foundation

// Curent Weather
struct CurrentWeather: Decodable {
    let main: MainInfo
    let weather: [WeatherInfo]
    let wind: WindInfo
    let clouds: CloudsInfo
    let name: String
    
    struct MainInfo: Decodable {
        let temp: Double
        let humidity: Int
    }

    struct WeatherInfo: Decodable {
        let description: String
    }

    struct WindInfo: Decodable {
        let speed: Double
    }
    
    struct CloudsInfo: Decodable {
        let all: Int
    }
}

// Forecasting weather
struct ForecastItem: Decodable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: [WeatherInfo]
    let wind: WindInfo

    struct MainInfo: Decodable {
        let temp: Double
        let humidity: Int
    }

    struct WeatherInfo: Decodable {
        let description: String
    }

    struct WindInfo: Decodable {
        let speed: Double
    }
}

struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

// UV Index
struct UVIndex: Decodable {
    let value: Double
}

// Air Quality
struct AirQuality: Decodable {
    let list: [AirQualityItem]

    struct AirQualityItem: Decodable {
        let main: Main
        let components: Components
        
        struct Main: Decodable {
            let aqi: Int // 1 = Good, 5 = Very Poor
        }

        struct Components: Decodable {
            let pm2_5: Double
            let pm10: Double
            let no2: Double
            let o3: Double
        }
    }
}

