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

    var body: some View {
        ZStack {
            // Gradiente base
            LinearGradient(
                colors: [color.opacity(0.3), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()

            // Orbes flotantes
            Circle()
                .fill(color.opacity(0.4))
                .frame(width: 300, height: 300)
                .offset(x: animate ? -120 : 180, y: animate ? -200 : 250)
                .blur(radius: 80)

            Circle()
                .fill(Color("AccentColor").opacity(0.3))
                .frame(width: 250, height: 250)
                .offset(x: animate ? 100 : -150, y: animate ? 150 : -200)
                .blur(radius: 70)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}
