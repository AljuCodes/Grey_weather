//
//  WeatherView.swift
//  Grey Weather
//
//  Created by FAO on 23/10/23.
//

import SwiftUI

struct WeatherView: View {
    @State var searchText: String = ""
    
    var searchResults: [Forecast]{
        if searchText.isEmpty {
            return Forecast.cities
        } else {
            return Forecast.cities.filter{ $0.location.contains(searchText)}
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color.background.ignoresSafeArea()
            
            // MARK: Weather Widgets
            
            ScrollView(showsIndicators: false){
                VStack(spacing: 20){
                    ForEach(searchResults){ forecast in
                        WeatherWidget(forecast: forecast)
                        
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                EmptyView().frame(height: 110)
            }
        }.overlay{
            NavigationBar(searchText: $searchText)
        }
        .toolbar(.hidden, for: .automatic)
    }
}

#Preview {
    WeatherView().preferredColorScheme(.dark)
}
