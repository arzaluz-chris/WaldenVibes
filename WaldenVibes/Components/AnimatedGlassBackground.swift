//
//  AnimatedGlassBackground.swift
//  WaldenVibes
//
//  Created by Claude Code
//

import SwiftUI

@available(iOS 26.0, *)
struct AnimatedGlassBackground: View {
    let color: Color
    @State private var animate = false
    @State private var isVisible = false

    var body: some View {
        ZStack {
            // Gradiente base - siempre visible
            LinearGradient(
                colors: [color.opacity(0.3), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Orbes flotantes - solo si la vista está visible
            if isVisible {
                Circle()
                    .fill(color.opacity(0.35))
                    .frame(width: 280, height: 280)
                    .offset(x: animate ? -100 : 160, y: animate ? -180 : 230)
                    .blur(radius: 70)

                Circle()
                    .fill(Color("AccentColor").opacity(0.25))
                    .frame(width: 230, height: 230)
                    .offset(x: animate ? 80 : -130, y: animate ? 130 : -180)
                    .blur(radius: 60)
            }
        }
        .onAppear {
            // Pequeño delay antes de iniciar animaciones para mejor rendimiento inicial
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isVisible = true
                withAnimation(.easeInOut(duration: 18).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
        .onDisappear {
            // Detener animaciones cuando la vista desaparece
            isVisible = false
            animate = false
        }
    }
}
