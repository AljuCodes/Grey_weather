//
//  ContentView.swift
//  Grey Weather
//
//  Created by FAO on 19/10/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManger = LocationManager()
    @State var weather: WeatherResponse?
    var weatherManager = WeatherManager()
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            if let location = locationManger.location {
                if let weather = weather  {
                    HomeView(weather: weather).environmentObject(locationManger)
                } else {
                    LoadingView().task {
                        do {
                            weather = try await weatherManager.getCurrentWeather(lat: location.latitude, lon: location.longitude)
                        } catch {
                            print("Error Getting the weather data")
                        }
                    }
                }
                
            } else  {
                LoadingView()
            }
         
           
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
