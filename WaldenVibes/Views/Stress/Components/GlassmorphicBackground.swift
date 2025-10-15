// WaldenVibes/Components/GlassmorphicBackground.swift
import SwiftUI

@available(iOS 26.0, *)
struct GlassmorphicBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color("AccentColor").opacity(0.15), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Orbe 1
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 250, height: 250)
                .blur(radius: 100)
                .offset(x: animate ? 100 : -100, y: animate ? 150 : -150)

            // Orbe 2
            Circle()
                .fill(Color.purple.opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 120)
                .offset(x: animate ? -120 : 120, y: animate ? -200 : 200)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}