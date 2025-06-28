//  MeditationTipsView.swift
import SwiftUI

struct MeditationTipsView: View {
    private let tips = [
        "Take a deep breath in for 4 seconds, hold for 4, then exhale for 6",
        "Sit comfortably with your back straight and shoulders relaxed",
        "Focus on your breath - when your mind wanders, gently bring it back",
        "Be patient with yourself - meditation is a practice that improves over time"
    ]
    
    @State private var currentTipIndex = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Text("meditation.tips.title")
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
