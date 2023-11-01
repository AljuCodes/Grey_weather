//
//  ForecastCard.swift
//  Grey Weather
//
//  Created by FAO on 23/10/23.
//

import SwiftUI

struct ForecastCard: View {
    var isActive : Bool {
        if forecastPeriod == ForecastPeriod.hourly {
            let isThisHour = Calendar.current.isDate(
                .now,
                equalTo: forecast.date,
                toGranularity: .hour
            )
            return isThisHour
        } else {
            let isThisToday = Calendar.current.isDate(.now, equalTo: forecast.date, toGranularity: .day)
            return isThisToday
        }
    }
    var forecast: Forecast
    var forecastPeriod: ForecastPeriod
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.forecastCardBackground.opacity(isActive ? 1 : 0.2))
                .frame(width: 60, height: 146)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
                .overlay{
                    // Card Border
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(.white.opacity(isActive ? 0.5 : 0.2))
                        .blendMode(.overlay)
                }
                .innerShadow(
                    shape: RoundedRectangle(cornerRadius: 30),
                    color: .white.opacity(0.25),
                    lineWidth: 1,
                    offsetX: 1,
                    offsetY: 1,
                    blur: 0,
                    blendMode: .overlay
                )
            
            // MARK: Content
            VStack(spacing: 16) {
                // MARK: Forecast Date
                Text(
                    forecast.date,
                     format: forecastPeriod == ForecastPeriod.hourly ?
                        .dateTime.hour() : .dateTime.weekday()
                )
                .font(.subheadline.weight(.semibold))
                
                VStack(spacing: -4) {
                    Image("\(forecast.icon) small")
                    
                    // MARK: Forecast Probability
                    Text(forecast.probability, format: .percent)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(Color.probabilityText)
                        .opacity(forecast.probability > 0 ? 1 : 0)
                }.frame(height: 42)
                // MARK: Forecast Temperature
                Text("\(forecast.temperature)°").font(.title3)
            }.padding()
            
        }
    }
}

#Preview {
    ForecastCard(forecast: Forecast.hourly[1], forecastPeriod: .hourly)
}
