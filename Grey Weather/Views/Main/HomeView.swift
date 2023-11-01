//
//  HomeView.swift
//  Grey Weather
//
//  Created by FAO on 21/10/23.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition : CGFloat, CaseIterable {
    case top = 0.83
    case middle = 0.385
}

struct HomeView: View {
    
    // Animation States
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged = false
    // Location States
    @EnvironmentObject var locationManager: LocationManager
    
    // Weather States
    @State var weather: WeatherResponse
    
    private var weatherDetail: WeatherResponse.MainResponse {
        return weather.main
    }
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation -  BottomSheetPosition.middle.rawValue) /
        ( BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    var body: some View {
        let totalHeight = UIScreen.main.bounds.height
        
        NavigationStack {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                let imageOffset = screenHeight + 36
                Color.background.ignoresSafeArea()
                    
                ZStack{
                    // MARK: Background Color
 
                    // MARK: BackgroundImage
                    Image("Background").resizable().ignoresSafeArea()
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    //MARK: House Image
                    
                    Image("House").frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top).padding(.top, totalHeight/3.5)
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    // MARK: Current Weather
                    VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) { 
                                Text(weather.name).font(.largeTitle)
                        VStack {
                            Text(attributedString).multilineTextAlignment(.center)
                            Text("H: \(weatherDetail.tempMax.roundDouble())°   L: \(weatherDetail.tempMin.roundDouble())°")
                                .font(.title3.weight(.semibold))
                                .opacity(1 - bottomSheetTranslationProrated)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 51)
                    .offset(y: -bottomSheetTranslationProrated * 46)
                    
                    // MARK: BottomSheet
                    BottomSheetView(position: $bottomSheetPosition) {
                        } content: {
                            ForecastView(bottomSheetTranslationProrated: bottomSheetTranslationProrated, hasDragged: $hasDragged, weatherCardModles: getWeatherCardModels(weather))
                    }
                    .onBottomSheetDrag { translation in
                        bottomSheetTranslation = translation / screenHeight
                        
                        withAnimation(.easeInOut){
                            if bottomSheetPosition == BottomSheetPosition.top {
                                hasDragged = true
                            } else {
                                hasDragged = false
                            }
                        }
                    }
                    //MARK: TAB Bar
                    TabBar(
                        action: {
                        bottomSheetPosition = .top
                        }).offset(y: bottomSheetTranslationProrated * 115)
                }.navigationBarBackButtonHidden(true)
            }
        }
    }
    
    
    private func getWeatherCardModels(_ response :WeatherResponse) -> [WeatherCardData] {
         let mainResponse = response.main
        let windResponse = response.wind
        var dataList: [WeatherCardData] = []
        // feels like
        dataList.append(WeatherCardData(
            iconName: "thermometer.medium",
            heading: "FEELS LIKE",
            mainTitle: "\(mainResponse.feelsLike.roundDouble())°",
            message: "Similar to the actual temperature"
        ))
        
        // Pressure
        dataList.append(WeatherCardData(
            iconName: "barometer",
            heading: "PRESSURE",
            mainTitle: "\(mainResponse.pressure.roundDouble())",
            message: "Normal Pressure for this temperature"
        ))

        
        // humidity
        dataList.append(WeatherCardData(
            iconName: "humidity",
            heading: "HUMIDITY",
            mainTitle: "\(mainResponse.humidity.roundDouble())%",
            message: "The dew point is good right now"
        ))
        
        // humidity
        dataList.append(WeatherCardData(
            iconName: "wind",
            heading: "WIND",
            mainTitle: "Speed: \(windResponse.speed.roundDouble())Km/h Deg: \(windResponse.deg.roundDouble())",
            message: "Don't forget to close the windows"
        ))
        
        
        return dataList
    }
    
    private var attributedString:  AttributedString {
        let tempInCelcius = "\(weather.main.temp.roundDouble())°"
                
        let weatherMessage = String(describing: weather.weather.first!.description).capitalized
        
        var string = AttributedString(tempInCelcius + (hasDragged ? " | " : "\n ") + weatherMessage)
        
        if let celciusSymbol = string.range(of: "°"){
            string[celciusSymbol].font = .system(size: hasDragged ? 12 : 24)
        }
            
        if let temp = string.range(of: tempInCelcius){
            string[temp].font = .system(size: (86 - (bottomSheetTranslationProrated * (86 - 20))), weight: hasDragged ? .semibold : .thin)
            string[temp].foregroundColor = hasDragged ? .secondary : .primary
        }
        
        if let pipe = string.range(of: " | ") {
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .secondary.opacity(bottomSheetTranslationProrated)
        }
        
        if let weather = string.range(of: weatherMessage) {
            string[weather].font = .title3.weight(.semibold)
            string[weather].foregroundColor = .secondary
        }
        
        return string
    }
}

#Preview {
    HomeView(weather: getWeather()).preferredColorScheme(.dark)
}

struct LoadingView: View {
    var body: some View {
        ProgressView().frame(width: 60, height: 60)
    }
}

private func getWeather()-> WeatherResponse {
    let coordinates = WeatherResponse.CoordinatesResponse(lon: 45.6789, lat: 12.3456)

    let weather = WeatherResponse.WeatherResponse(id: 801, main: "Clouds", description: "Haze", icon: "03d")

    let main = WeatherResponse.MainResponse(temp: 30, feels_like: 26.3, temp_min: 30.0, temp_max: 30.5, pressure: 1015.2, humidity: 70.0)

    let wind = WeatherResponse.WindResponse(speed: 10.5, deg: 150.0)

    return WeatherResponse(coord: coordinates, weather: [weather], main: main, name: "Aluva", wind: wind)
}
