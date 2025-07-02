// WaldenVibes/Views/Main/SplashView.swift
import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @Binding var isShowingSplash: Bool
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color("AccentColor"),
                    Color("AccentColor").opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // App Icon
                Image(systemName: "leaf.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                // App Name
                Text("Walden Vibes")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.3), value: showContent)
                
                // Tagline
                Text("Your emotional well-being matters", comment: "App tagline in splash screen")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.5), value: showContent)
            }
        }
        .onAppear {
            isAnimating = true
            showContent = true
            
            // Dismiss splash after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isShowingSplash = false
                }
            }
        }
    }
}
