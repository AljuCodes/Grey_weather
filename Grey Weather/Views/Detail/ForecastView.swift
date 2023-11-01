//
//  ForecastView.swift
//  Grey Weather
//
//  Created by FAO on 22/10/23.
//

import SwiftUI

struct WeatherCardData: Hashable {
    init(iconName: String = "wind", heading: String = "WIND", mainTitle: String = "Speed: 3.09  Deg: 320", message: String = "Take sunglasses for eye protection") {
        self.iconName = iconName
        self.heading = heading
        self.mainTitle = mainTitle
        self.message = message
    }
     var iconName = "wind"
     var heading = "WIND"
     var mainTitle = "Speed: 3.09  Deg: 320"
     var message = "Take sunglasses for eye protection"
}

struct ForecastView: View {
    var bottomSheetTranslationProrated: CGFloat = 1
    @State  var selection = 0
    @Binding  var hasDragged: Bool
    var progress = 0.8
    var weatherCardModles: [WeatherCardData]
    
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20, content: {
                SegmentedControl(seleciton: $selection)
                
                // MARK: Segmented Control
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 12){
                        if selection == 0 {
                            ForEach(Forecast.hourly ){ forecast in
                                ForecastCard(forecast: forecast, forecastPeriod: .hourly)
                            }.transition(.offset(x: -430))
                        } else {
                            ForEach(Forecast.weekly ){ forecast in
                                ForecastCard(forecast: forecast, forecastPeriod: .weekly)
                            }.transition(.offset(x: 430))
                        }
                    }.padding(.vertical, 20)
                }
                VStack{}.frame(width: 1, height: hasDragged ? 0:  80)
                //            list of widgets
                VStack(spacing: 20) {
                    // visiblity card
                    VisibilityCard(progress: progress)
                    // Second wind speed, pressure
                    WeatherCardGrid(models: weatherCardModles)
                    
                }.padding(.horizontal, 20)
            })
        }.backgroundBlur(radius: 25, opaque: true)
            .clipShape(RoundedRectangle(cornerRadius: 44))
            .innerShadow(
                shape: RoundedRectangle(cornerRadius: 44),
                color: Color.bottomSheetBorderMiddle,
                lineWidth: 1, offsetX: 0, offsetY: 1,
                blur: 0, blendMode: .overlay,
                opacity: 1 - bottomSheetTranslationProrated
            )
            .overlay{
                Divider().blendMode(.overlay)
                    .background(Color.bottomSheetBorderTop)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: 44))
            }.overlay {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.3))
                    .frame(width: 48, height: 5)
                    .frame(height: 20)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
    }
}

//
//#Preview {
//    ForecastView().background(Color.tabBarBackground).preferredColorScheme(.dark)
//}

struct WeatherCardGrid: View {
    let models: [WeatherCardData]

    var body: some View {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(maximum:168), spacing: 20),
                    GridItem(.flexible(maximum:168))
                ]
            ) {
                ForEach(models, id: \.self) { item in
                    WeatherCard(cardData: item)
                }
            }
        }
}

struct VisibilityCard: View {
    var progress: CGFloat
    var body: some View {
        // visiblity card
        RoundedRectangle(cornerRadius: 24) // Set the desired corner radius
            .stroke(Color.gray, lineWidth: 1) // Apply a gray border
            .frame(
                maxWidth: .infinity,
                minHeight: 168,
                alignment: .leading
            )
            .overlay(VStack(alignment: .leading, spacing: 15){
                
                //  down lo header
                HStack {
                    Image(systemName: "eye")
                    Text("Visibility")
                }
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
                
                // Main heading
                Text("3 Km -Low Road Accident Risk")
                    .font(.title3.bold())
                // slider
                GradientSlider(progress: progress)
                //divider
                Divider()
                // under actiono
                HStack {
                    Text("See more")
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(Color.secondary)
                }
            }.padding(.all, 20)
            )
            .frame(
                maxWidth: .infinity,
                minHeight: 168,
                alignment: .leading
            )
            .background(Color.background2)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct GradientSlider: View {
 var progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                LinearGradient(
                    gradient:
                        Gradient(colors: 
                                    [
                                        Color(hue: 0.6, saturation: 1.0, brightness: 1.0),
                                        Color(hue: 0.8, saturation: 1.0, brightness: 1.0),
                                        Color(hue: 0.9, saturation: 0.8, brightness: 1.0),
                                        Color(hue: 0.95, saturation: 1.0, brightness: 1.0)
                                    ]
                                ),
                    startPoint: .leading,
                    endPoint: .trailing
                ).frame( maxHeight: 5)
                    .cornerRadius(10)
                
                HStack(spacing: 0) {
                    HStack{}.frame(minWidth: geometry.size.width * progress, maxHeight: 5)
                    Circle().frame(width: 6)
                    Spacer()
                }.frame(maxWidth: .infinity)
            }
        }
    }
}

struct WeatherCard: View {
    var cardData: WeatherCardData
    var isBigFont: Bool!
    init(cardData: WeatherCardData) {
        self.cardData = cardData
        print("\(cardData.mainTitle.count) for title \(cardData.mainTitle)")
        if cardData.mainTitle.count < 5 {
            isBigFont = true
       } else {
           isBigFont = false
       }
           
    }
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(Color.gray, lineWidth: 1)
            .frame(maxWidth: .infinity, maxHeight: 168, alignment: .leading)
            .overlay(
                VStack(alignment: .leading) {
                    // Down lo header
                    HStack(spacing: 2) {
                        Image(systemName: cardData.iconName)
                        Text(cardData.heading)
                        
                    }
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
                    
                    // Main heading
                    Text(cardData.mainTitle)
                        .font(isBigFont ?   .title : .title3).bold().padding(.top, 5)
                    // Disable line limit to allow wrapping
                    
                    Spacer()
                    
                    Text(cardData.message)
                        .font(.footnote)
                }
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 10, trailing: 10))
                //
            )
            .frame(maxWidth: .infinity, minHeight: 168, alignment: .leading)
            .background(Color.background2)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
