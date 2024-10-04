//
//  ContentView.swift
//  Waves
//
//  Created by Mostafa on 03/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var touchPosition: CGPoint = .zero
    
    var body: some View {
        ZStack {
            EmitterView(position: touchPosition)
                .ignoresSafeArea()
            
            // Capture tap gesture to update the particle position
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { location in
                    // Update the position of the emitter to the tap location
                    touchPosition = CGPoint(x: location.x, y: location.y)
                }
        }
    }
}
