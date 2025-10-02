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
                // Animated glass background
                AnimatedGlassBackground(color: Color("AccentColor"))

                VStack(spacing: 24) {
                    // App Icon from Assets with glassmorphic container
                    ZStack {
                        Circle()
                            .fill(.regularMaterial)
                            .frame(width: 150, height: 150)
                            .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 12)
                            .overlay(
                                Circle()
                                    .stroke(LinearGradient(
                                        colors: [.white.opacity(0.6), .white.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ), lineWidth: 2)
                            )

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
                    }

                    // App Name with enhanced contrast
                    VStack(spacing: 12) {
                        Text("Walden Vibes")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, Color.white.opacity(0.95)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
                            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.3), value: showContent)

                        // Tagline with enhanced contrast
                        Text("Your emotional well-being matters", comment: "App tagline in splash screen")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.5), value: showContent)
                    }
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
