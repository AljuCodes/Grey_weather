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
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    let degreeInCelcius: String = "19°"
    let weatherMessage: String = "Mostly Clear"
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
                ZStack{
                    // MARK: Background Color
                    Color.background.ignoresSafeArea()
                    
                    // MARK: BackgroundImage
                    Image("Background").resizable().ignoresSafeArea()
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    //MARK: House Image
                    
                    Image("House").frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top).padding(.top, totalHeight/3.5)
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    //MARK: Weather Content
                    VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                        
                        Text("Montreal").font(.largeTitle)
                        
                        VStack{
                            Text(getAttributedString)
                            
                            Text("H:24°     L:18°")
                                .font(.title3.weight(.semibold))
                                .opacity(1 - bottomSheetTranslationProrated)
                        }
                        Spacer()
                    }
                    .padding(.top, 51)
                    .offset(y: -bottomSheetTranslationProrated * 46)
                    
                    // MARK: BottomSheet
                    BottomSheetView(position: $bottomSheetPosition) {
                            Text(bottomSheetTranslationProrated.formatted())
                        } content: {
                        ForecastView()
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
    
    private var getAttributedString:  AttributedString {
        var string = AttributedString(degreeInCelcius + (hasDragged ? " | " : "\n" )  + weatherMessage)
        
        if let temp = string.range(of: degreeInCelcius){
            string[temp].font = .system(size: (96 - (bottomSheetTranslationProrated - (96 - 20))), weight: .thin)
            string[temp].foregroundColor = .primary
        }
        
        if let pipe = string.range(of: " | "){
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .secondary
        }
            if let weather = string.range(of: weatherMessage){
            string[weather].font = .title3.weight( .semibold)
            string[weather].foregroundColor = .secondary
        }
        return string
    }
}

#Preview {
    HomeView().preferredColorScheme(.dark)
}
