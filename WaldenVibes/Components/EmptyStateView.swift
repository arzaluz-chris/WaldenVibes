// WaldenVibes/Components/EmptyStateView.swift
import SwiftUI

struct EmptyStateView: View {
    let imageName: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let buttonTitle: LocalizedStringKey?
    let buttonAction: (() -> Void)?
    
    init(
        imageName: String,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        buttonTitle: LocalizedStringKey? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                // Animated floating orbs
                FloatingOrbsView()

                // Main content with material background
                VStack(spacing: 24) {
                    content
                }
                .padding(32)
                .background(.regularMaterial)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.1), radius: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(LinearGradient(
                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1.5)
                )
                .padding(40)
            }
        } else {
            // MARK: - iOS 18 Design
            VStack(spacing: 20) {
                content
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        // Check if it's a system image or custom image
        if imageName.contains(".") {
            // Custom image from Assets
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .opacity(0.5)
        } else {
            // SF Symbol
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(Color("AccentColor").opacity(0.5))
        }
        
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
        
        Text(subtitle)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
        
        if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
            if #available(iOS 26.0, *) {
                Button(action: buttonAction) {
                    Label(buttonTitle, systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color("AccentColor").opacity(0.8))
                        .background(.thinMaterial)
                        .cornerRadius(25)
                        .shadow(color: Color("AccentColor").opacity(0.3), radius: 10, x: 0, y: 5)

                }
                .padding(.top, 10)
            } else {
                Button(action: buttonAction) {
                    Label(buttonTitle, systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color("AccentColor"))
                        .cornerRadius(25)
                }
                .padding(.top, 10)
            }
        }
    }
}

// Helper view for animated orbs, specific to iOS 26+
@available(iOS 26.0, *)
struct FloatingOrbsView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.purple.opacity(0.3))
                .frame(width: 200, height: 200)
                .offset(x: animate ? -100 : 150, y: animate ? -150 : 200)
            
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 250, height: 250)
                .offset(x: animate ? 120 : -150, y: animate ? 100 : -220)
        }
        .blur(radius: 60)
        .onAppear {
            withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}
