//
//  Blur.swift
//  Grey Weather
//
//  Created by FAO on 23/10/23.
//

import SwiftUI

class UIBackdropView: UIView {
    override class var layerClass: AnyClass {
        NSClassFromString("CABackdropLayer") ?? CALayer.self
    }
}

struct Backdrop: UIViewRepresentable {
    func updateUIView(_ uiView: UIBackdropView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> UIBackdropView {
        UIBackdropView()
    }
}

struct Blur: View {
    var radius: CGFloat = 3
    var opaque: Bool = false
    
    var body: some View {
        Backdrop().blur(radius: radius, opaque: opaque)
    }
}

#Preview {
    Blur()
}
