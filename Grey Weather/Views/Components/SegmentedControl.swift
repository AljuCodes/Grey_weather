//
//  SegmentedControl.swift
//  Grey Weather
//
//  Created by FAO on 23/10/23.
//

import SwiftUI

struct SegmentedControl: View {
    @Binding var seleciton: Int
    
    var body: some View {
        VStack(spacing: 5){
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.5)){
                        seleciton = 0
                    }
                } label: {
                    Text("Hourly Forecast")
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.5)){
                        seleciton = 1
                    }
                } label: {
                    Text("Weekly Forecast")
                }.frame(minWidth: 0, maxWidth: .infinity)
                
            }
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.secondary)
            
            //MARK: Underline
            HStack {
                Divider()
                    .frame(width:
                            UIScreen.main.bounds.width / 2,
                           height: 3)
                    .background(Color.underline)
                    .blendMode(.overlay)
            }.frame(
                maxWidth: .infinity, alignment:  seleciton == 0 ? .leading : .trailing).offset(y: -1)
        }
        .padding(.top, 25)
    }
}

#Preview {
    SegmentedControl(seleciton: .constant(0))
}
