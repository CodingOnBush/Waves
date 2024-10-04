//
//  UIViewRepresentable.swift
//  Waves
//
//  Created by Mostafa on 03/10/2024.
//

import SwiftUI
import UIKit

// UIViewRepresentable to integrate CAEmitterLayer into SwiftUI
struct EmitterView: UIViewRepresentable {
    var position: CGPoint

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Create and configure the emitter layer
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .point
        emitterLayer.emitterPosition = position
        
        // Configure the particle
        let cell = CAEmitterCell()
        cell.contents = UIImage(systemName: "heart.fill")?.cgImage // You can use any shape
        cell.scale = 0.2  // size of the particle
        cell.birthRate = 1000
        cell.lifetime = 1
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionRange = .pi * 2
        cell.yAcceleration = 0.5  // No gravity effect
        cell.xAcceleration = 0
        cell.alphaSpeed = -1.0
        
        // Add the cell to the emitter layer
        emitterLayer.emitterCells = [cell]
        view.layer.addSublayer(emitterLayer)
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the position of the emitter layer
        if let emitterLayer = uiView.layer.sublayers?.first as? CAEmitterLayer {
            emitterLayer.emitterPosition = position
        }
    }
}

