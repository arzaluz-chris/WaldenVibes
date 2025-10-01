// WaldenVibes/Views/Meditation/MeditationTipsView.swift
import SwiftUI

struct MeditationTipsView: View {
    private let tips = [
        String(localized: "Take a deep breath in for 4 seconds, hold for 4, then exhale for 6", comment: "Meditation breathing tip"),
        String(localized: "Sit comfortably with your back straight and shoulders relaxed", comment: "Meditation posture tip"),
        String(localized: "Focus on your breath - when your mind wanders, gently bring it back", comment: "Meditation focus tip"),
        String(localized: "Be patient with yourself - meditation is a practice that improves over time", comment: "Meditation patience tip")
    ]
    
    @State private var currentTipIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(spacing: 12) {
                Text("Tips", comment: "Header for meditation tips section")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(tips[currentTipIndex])
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 30)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(minHeight: 50)
                    .id(currentTipIndex) // Use ID to force view update for transition
                    .transition(.opacity.animation(.easeInOut))
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .onAppear(perform: startTimer)
            .onDisappear { timer?.invalidate() }

        } else {
            // MARK: - iOS 18 Design
            VStack(spacing: 12) {
                Text("Tips", comment: "Header for meditation tips section")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(tips[currentTipIndex])
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 30)
                    .fixedSize(horizontal: false, vertical: true) // Allow text to expand vertically
                    .frame(minHeight: 50) // Ensure minimum height for longer tips
                    .animation(.easeInOut, value: currentTipIndex)
            }
            .frame(maxWidth: .infinity)
            .onAppear(perform: startTimer)
            .onDisappear { timer?.invalidate() }
        }
    }
    
    private func startTimer() {
        timer?.invalidate() // Ensure no duplicate timers
        timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true) { _ in
            currentTipIndex = (currentTipIndex + 1) % tips.count
        }
    }
}
