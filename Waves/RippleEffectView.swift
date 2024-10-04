//
//  RippleEffectView.swift
//  Waves
//
//  Created by Mostafa on 03/10/2024.
//

import SwiftUI

struct RippleEffectView: View {
    @State private var rippleScale: CGFloat = 0.1
    @State private var rippleOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Circle()
                .stroke(Color.blue, lineWidth: 2)
                .scaleEffect(rippleScale)
                .opacity(rippleOpacity)
                .frame(width: 200, height: 200)
                .onAppear {
                    withAnimation(Animation.easeOut(duration: 1.0)) {
                        self.rippleScale = 3.0
                        self.rippleOpacity = 0.0
                    }
                }
        }
    }
}
