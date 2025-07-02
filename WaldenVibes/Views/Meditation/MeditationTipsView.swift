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
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Tips", comment: "Header for meditation tips section")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(tips[currentTipIndex])
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .animation(.easeInOut, value: currentTipIndex)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                withAnimation {
                    currentTipIndex = (currentTipIndex + 1) % tips.count
                }
            }
        }
    }
}
