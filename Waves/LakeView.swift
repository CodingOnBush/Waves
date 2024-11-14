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

struct LakeView: View {
    @State private var tapLocation: CGPoint = .zero
    @State private var ripples: [Ripple] = []
    @State private var isTouching: Bool = false // Pour suivre l'état de l'appui
    @State private var rippleTimer: Timer? // Timer pour créer les vagues
    
    @State private var Rsize: CGFloat = 0;
    @State private var RmaxSize: CGFloat = 700;
    @State private var Rduration = 5.0;
    @State private var RrippleSize = 0;
    @State private var Ropacity = 0.9;
    @State private var count: Int = 0;

    // Générateur haptique pour la vibration
    let impactFeedback = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        VStack {
            ZStack {
                // Fond de la vue (pellicule d'eau)
//                Color.black
//                    .ignoresSafeArea()
                Image("back")
                    .resizable() // Rendre l'image redimensionnable
                    .scaledToFill() // La remplir en gardant les proportions
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Assure qu'elle prend toute la vue
                    .edgesIgnoringSafeArea(.all)

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
                            if (count > 5) {
                                count = 0
                            }
                            count += 1
                        }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        tapLocation = value.location
                        print("(\(tapLocation.x), \(tapLocation.y)")
                        isTouching = true
                        startCreatingRipples()
                    }
                    .onEnded { _ in
                        isTouching = false
                        stopCreatingRipples()
                    }
            )
        }
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
        let newRipple = Ripple(id: UUID(), location: location, size: Rsize, maxSize: RmaxSize, duration: Rduration, opacity: Ropacity)
        ripples.append(newRipple)

        // Déclencher une vibration légère
        if (count == 5)
        {
            impactFeedback.impactOccurred()
        }

        // Nettoyage des vagues terminées
        DispatchQueue.main.asyncAfter(deadline: .now() + newRipple.duration) {
            ripples.removeAll { $0.id == newRipple.id }
        }
    }
}
