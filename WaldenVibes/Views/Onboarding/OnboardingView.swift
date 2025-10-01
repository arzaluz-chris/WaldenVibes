// WaldenVibes/Views/Onboarding/OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: LocalizedStringKey("Welcome to Walden Vibes"),
            description: LocalizedStringKey("Your personal companion for emotional well-being and mindfulness"),
            imageName: "heart.circle.fill",
            backgroundImage: "OnboardingWelcome",
            color: Color("AccentColor")
        ),
        OnboardingPage(
            title: LocalizedStringKey("Track Your Emotions"),
            description: LocalizedStringKey("Record how you feel and discover patterns in your emotional journey"),
            imageName: "face.smiling.fill",
            backgroundImage: "OnboardingEmotions",
            color: Color("EmotionHappy")
        ),
        OnboardingPage(
            title: LocalizedStringKey("Improve Your Well-being"),
            description: LocalizedStringKey("Practice meditation, manage stress, and capture special moments"),
            imageName: "sparkles",
            backgroundImage: "OnboardingWellness",
            color: Color("EmotionCalm")
        )
    ]
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                // Animated gradient and orbs background
                AnimatedGlassBackground(color: pages[currentPage].color)
                
                VStack {
                    // Skip button
                    HStack {
                        Spacer()
                        Button("Skip") {
                            withAnimation(.easeOut) {
                                hasSeenOnboarding = true
                            }
                        }
                        .foregroundColor(.primary.opacity(0.8))
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        .padding()
                    }
                    
                    // Page content
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Page indicator and continue button
                    VStack(spacing: 30) {
                        // Custom page indicator
                        HStack(spacing: 10) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Capsule()
                                    .fill(currentPage == index ? pages[currentPage].color : .white.opacity(0.3))
                                    .frame(width: currentPage == index ? 25 : 8, height: 8)
                                    .animation(.spring(), value: currentPage)
                            }
                        }
                        
                        // Continue/Get Started button
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation(.easeInOut) {
                                    currentPage += 1
                                }
                            } else {
                                withAnimation(.easeOut) {
                                    hasSeenOnboarding = true
                                }
                            }
                        }) {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(pages[currentPage].color.opacity(0.8))
                                .background(.regularMaterial)
                                .cornerRadius(25)
                                .shadow(color: pages[currentPage].color.opacity(0.4), radius: 10, x: 0, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.white.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 50)
                }
            }
        } else {
            // MARK: - iOS 18 Design
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        pages[currentPage].color.opacity(0.3),
                        pages[currentPage].color.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut, value: currentPage)
                
                VStack {
                    // Skip button
                    HStack {
                        Spacer()
                        Button("Skip") {
                            withAnimation {
                                hasSeenOnboarding = true
                            }
                        }
                        .foregroundColor(.secondary)
                        .padding()
                    }
                    
                    // Page content - removed page indicators from TabView
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default indicators
                    
                    // Page indicator and continue button
                    VStack(spacing: 30) {
                        // Custom page indicator
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? pages[currentPage].color : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(currentPage == index ? 1.2 : 1)
                                    .animation(.spring(), value: currentPage)
                            }
                        }
                        
                        // Continue/Get Started button
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                withAnimation {
                                    hasSeenOnboarding = true
                                }
                            }
                        }) {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(pages[currentPage].color)
                                .cornerRadius(25)
                                .shadow(color: pages[currentPage].color.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage {
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let imageName: String
    let backgroundImage: String?
    let color: Color
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(spacing: 40) {
                Spacer()
                
                // Icon within a material container
                ZStack {
                    Circle()
                        .fill(page.color.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 20)

                    Image(systemName: page.imageName)
                        .font(.system(size: 100))
                        .foregroundColor(page.color)
                        .shadow(color: .white.opacity(0.5), radius: 10)
                }
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                // Title
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Description
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                Spacer()
            }
            .onAppear { isAnimating = true }

        } else {
            // MARK: - iOS 18 Design
            ZStack {
                // Background image
                if let backgroundImage = page.backgroundImage {
                    Image(backgroundImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.1)
                        .ignoresSafeArea()
                }
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Icon
                    Image(systemName: page.imageName)
                        .font(.system(size: 120))
                        .foregroundColor(page.color)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    // Title
                    Text(page.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Description
                    Text(page.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    Spacer()
                }
            }
            .onAppear { isAnimating = true }
        }
    }
}

// iOS 26+ specific background view
@available(iOS 26.0, *)
struct AnimatedGlassBackground: View {
    let color: Color
    @State private var animate = false

    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [color.opacity(0.3), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            // Floating orbs
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
