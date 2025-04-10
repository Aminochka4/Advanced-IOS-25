//
//  ContentView.swift
//  WeatherDataApp
//
//  Created by Амина Аманжолова on 08.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var showAirQualityInfo = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    // Current Weather
                    if let current = viewModel.currentWeather {
                        VStack() {
                            Text("\(current.main.temp, specifier: "%.1f")°C")
                                .font(.system(size: 70, weight: .bold, design: .default))
                                .padding(.top, 50)
                            Spacer()
                            Text("\(current.weather.first?.description ?? "") in \(current.name)")
                                .font(.title)
                                .bold()
                            Spacer(minLength: 50)
                            VStack{
                                placeTextWithValue(leftText: "Wind Speed", value: Int(current.wind.speed), rightText: "m/s")
                                placeTextWithValue(leftText: "Humidity", value: Int(current.main.humidity), rightText: "%")
                                placeTextWithValue(leftText: "Clouds", value: Int(current.clouds.all), rightText: "%")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color("BeautyPurple")))
                            .foregroundColor(.white)
                        }
                        .padding()
                    } else {
                        Text(viewModel.currentWeatherError ?? "Loading current weather...")
                            .foregroundColor(.gray)
                            .padding()
                    }

                    // UV Index
                    if let uv = viewModel.uvIndex {
                        VStack {
                            Text("\(uv.value, specifier: "%.1f")")
                                .font(.system(size: 70, weight: .bold, design: .default))
                            Spacer()
                            Text("UV Index")
                                .font(.title)
                                .bold()
                        }
                        .padding()
                    } else if let error = viewModel.uvIndexError {
                        Text("UV Error: \(error)")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // Air Quality
                    if let air = viewModel.airQuality {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Air Quality")
                                    .font(.title)
                                    .bold()
                                    .padding(.leading, 5)

                                Button(action: {
                                    withAnimation {
                                        showAirQualityInfo.toggle()
                                    }
                                }) {
                                    Image(systemName: "questionmark.circle")
                                        .foregroundColor(.white)
                                }
                            }

                            if showAirQualityInfo {
                                Text("Air quality describes how clean or polluted the air is. \nAQI(Air Quality Index) - it summarizes the level of air pollution. \nPM2.5(Particulate Matter < 2.5 micrometers) - it summarizes tiny particles in the air, that can penetrate deep into the lungs. \nPM10(Particulate Matter < 10 micrometers) - it summarizes slightly larger particles than PM2.5 and can still cause respiratory issues.")
                                    .font(.headline)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color("BeautyPurple"))
                                            .shadow(radius: 5)
                                    )
                                    .padding(.bottom, 10)
                                    .transition(.opacity)
                            }

                            VStack {
                                placeTextWithValue(leftText: "AQI", value: Int(air.main.aqi), rightText: "")
                                placeTextWithValue(leftText: "PM2.5", value: Int(air.components.pm2_5), rightText: "µg/m³")
                                placeTextWithValue(leftText: "PM10", value: Int(air.components.pm10), rightText: "µg/m³")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color("BeautyPurple"))
                            )
                            .foregroundColor(.white)
                        }
                        .padding()
                    } else if let error = viewModel.airQualityError {
                        Text("Air Quality Error: \(error)")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }



                    // Forecast
                    if viewModel.isLoadingForecast {
                        ProgressView("Loading forecast...")
                            .padding()
                    } else if let error = viewModel.forecastError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("5-Day Forecast")
                                .font(.title)
                                .bold()
                                .padding(.leading, 5)

                            ForEach(viewModel.forecastItems, id: \.dt) { item in
                                VStack(alignment: .leading) {
                                    Text("\(DateFormatter.localizedString(from: Date(timeIntervalSince1970: item.dt), dateStyle: .short, timeStyle: .none))")
                                        .font(.title3)
                                        .padding(.leading, 5)
                                    HStack{
                                        Text(" \(item.main.temp, specifier: "%.1f")°C")
                                            .font(.title)
                                        Spacer()
                                        VStack(alignment: .leading){
                                            Text("\(item.weather.first?.description ?? "")")
                                            Text("Wind Speed: \(item.wind.speed, specifier: "%.1f") m/s")
                                        }
                                        .font(.title3)
                                    }
                                }
                                .padding(.vertical, 6)
                                Divider()
                                    .background(Color.white)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                .foregroundColor(.white)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkBlue"), Color("DarkPurple")]), startPoint: .top, endPoint: .bottom))
            .navigationBarTitle("Today's weather", displayMode: .inline)
            .toolbarBackground(Color("DarkBlue"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarItems(trailing: Button(action: {
            Task {
                await viewModel.fetchAll(city: "Almaty", lat: 43.25, lon: 76.95)
            }
            }) {
            Text("Reload")
                .font(.callout)
                .foregroundColor(.blue)
            })
            .task {
                await viewModel.fetchAll(city: "Almaty", lat: 43.25, lon: 76.95)
            }
        }
    }
}

// function for proper view
func placeTextWithValue(leftText: String, value: Int, rightText: String) -> some View {
    HStack {
        Text(leftText)
            .font(.title2)
            .bold()
        Spacer()
        Text("\(value) \(rightText)")
            .font(.title2)
    }
}


#Preview {
    ContentView()
}
