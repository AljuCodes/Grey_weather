//
//  WeatherWidget.swift
//  Grey Weather
//
//  Created by FAO on 23/10/23.
//

import SwiftUI

struct WeatherWidget: View {
    var forecast: Forecast
    var body: some View {
        // MARK: Trapezoid
        ZStack(alignment: .bottom) {
            
            Trapezoid()
                .fill(Color.weatherWidgetBackground)
                .frame(width: 342, height: 174)
                
        // MARK: Content
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    // MARK: Forecast Temperature
                    Text("\(forecast.temperature)°")
                        .font(.system(size: 64))
                    VStack(alignment: .leading){
                        Text("H:\(forecast.high)° L:\(forecast.low)°")
                            .font(.footnote)
                            .foregroundStyle(.foreground)
                        
                        // MARK: Forecast Location
                        Text(forecast.location)
                            .font(.body)
                            .lineLimit(1)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Image("\(forecast.icon) large")
                        .padding(.trailing, 4)
                    Text(forecast.weather.rawValue)
                        .font(.footnote)
                        .padding(.trailing, 24)
                    
                }
            }
            .foregroundStyle(.white)
                .padding(.bottom, 20)
                .padding(.leading, 20)
            }.frame(width: 342, height: 184, alignment: .bottom)
    }
}

#Preview {
    WeatherWidget(forecast: Forecast.cities[0])
}
