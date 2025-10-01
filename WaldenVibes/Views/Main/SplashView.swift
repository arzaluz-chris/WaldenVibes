// WaldenVibes/Views/Main/SplashView.swift
import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @Binding var isShowingSplash: Bool
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                // Animated gradient and orbs background
                AnimatedGlassBackground(color: Color("AccentColor"))

                VStack(spacing: 20) {
                    // App Icon within a glass container
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 150, height: 150)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                        
                        Image("LaunchLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                    }
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                    // App Name
                    Text("Walden Vibes")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                    
                    // Tagline
                    Text("Your emotional well-being matters", comment: "App tagline in splash screen")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 1.0), value: showContent)
            }
            .onAppear {
                isAnimating = true
                showContent = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isShowingSplash = false
                    }
                }
            }
        } else {
            // MARK: - iOS 18 Design
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
                    // App Icon from Assets
                    Image("LaunchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
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
}
