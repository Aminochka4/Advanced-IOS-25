# iOS Development Assignment: HeroApp

## Project Overview
I created a weather application that fetch multiple weather data points concurrently from a public weather API `https://home.openweathermap.org/` and display them to the user as each one finishes loading.

## Prerequisites
- Xcode 14+
- iOS 15+
- Swift 5+

## Setup
1. Clone the repository:
```
git clone https://github.com/Aminochka4/Advanced-IOS-25.git
```
2. Open the project (ImageGalleryApp) in Xcode
3. To get API key:
- Register on the website `https://home.openweathermap.org/`
- Get your personal API key in email 
- Use it intead of api_key in the code (in WeatherService.swift, 12 line)
4. Run the project on a simulator or a physical device

## Features implemented
1. The application shows several weather points:
- Temperature of the current day
- Condition of the current day
- Wind Speed of the current day
- Humidity of the current day
- Probability of cloudiness of the current day
- UV index of the current day
- Air quality of the current day
- 5-day forecast
2. There is button Reload
3. A popup that explains complex terms
4. Popup display includes animation
5. Implemented eye-pleasing UI
6. Implemented proper loading states
7. Implemented proper error handlings

### Technical side
1. All fetching funcionts work asynchronously
2. Implemented groupForecastByDay function for a sequential order in 5-day forecast
3. Implemented getMostCommonCondition function to show one common frequent condition

## Known issues or limitations
- No caching, dark mode, detail view of each component
- No location search functionality
- Only the Almaty point is configured, it can only be changed via code

## A short demo video
[Demo video](https://drive.google.com/file/d/1kRukbqEjmdh5sCNuvgtNHKcdrdTNEdVC/view?usp=sharing)
