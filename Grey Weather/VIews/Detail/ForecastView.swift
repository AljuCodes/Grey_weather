//
//  ForecastView.swift
//  Grey Weather
//
//  Created by FAO on 22/10/23.
//

import SwiftUI

struct ForecastView: View {
    var body: some View {
        ScrollView{
            
        }.backgroundBlur(radius: 25, opaque: true)
            .clipShape(RoundedRectangle(cornerRadius: 44))
            .innerShadow(shape: RoundedRectangle(cornerRadius: 44), color: Color.bottomSheetBorderMiddle, lineWidth: 1, offsetX: 0, offsetY: 1, blur: 0, blendMode: .overlay, opacity: 1)
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

#Preview {
    ForecastView().background(Color.tabBarBackground).preferredColorScheme(.dark)
}
