//
//  HomeView.swift
//  Waves
//
//  Created by Mostafa on 04/10/2024.
//

import SwiftUI
import UIKit // Import UIKit pour les vibrations

struct Ripple: Identifiable {
    let id: UUID
    let location: CGPoint
    var size: CGFloat
    let maxSize: CGFloat
    let duration: Double
    var opacity: Double
}

struct HomeView: View {
    @State private var tapLocation: CGPoint = .zero
    @State private var ripples: [Ripple] = []
    @State private var isTouching: Bool = false // Pour suivre l'état de l'appui
    @State private var rippleTimer: Timer? // Timer pour créer les vagues

    // Générateur haptique pour la vibration
    let impactFeedback = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        ZStack {
            // Fond de la vue (pellicule d'eau)
            Color.black
                .ignoresSafeArea()

            // Dessiner toutes les vagues
            ForEach(ripples) { ripple in
                Circle()
                    .stroke(Color.white.opacity(ripple.opacity), lineWidth: 0.8)
                    .frame(width: ripple.size, height: ripple.size)
                    .position(ripple.location)
                    .animation(.easeOut(duration: ripple.duration), value: ripple.size)
                    .onAppear {
                        // Mise à jour de la taille et de l'opacité de la vague lors de son apparition
                        withAnimation(.easeOut(duration: ripple.duration)) {
                            if let index = ripples.firstIndex(where: { $0.id == ripple.id }) {
                                ripples[index].size = ripple.maxSize
                                ripples[index].opacity = 0.0
                            }
                        }
                    }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    tapLocation = value.location
                    isTouching = true
                    startCreatingRipples()
                }
                .onEnded { _ in
                    isTouching = false
                    stopCreatingRipples()
                }
        )
    }

    // Fonction pour commencer à créer des vagues
    func startCreatingRipples() {
        // Si un timer est déjà actif, ne rien faire
        if rippleTimer == nil {
            rippleTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                if isTouching {
                    createRipple(at: tapLocation)
                }
            }
        }
    }

    // Fonction pour arrêter de créer des vagues
    func stopCreatingRipples() {
        rippleTimer?.invalidate()
        rippleTimer = nil
    }

    // Fonction pour ajouter une nouvelle vague
    func createRipple(at location: CGPoint) {
        let newRipple = Ripple(id: UUID(), location: location, size: 0, maxSize: 700, duration: 5.0, opacity: 0.9)
        ripples.append(newRipple)

        // Déclencher une vibration légère
        impactFeedback.impactOccurred()

        // Nettoyage des vagues terminées
        DispatchQueue.main.asyncAfter(deadline: .now() + newRipple.duration) {
            ripples.removeAll { $0.id == newRipple.id }
        }
    }
}
