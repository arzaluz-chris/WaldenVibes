//  MeditationTipsView.swift
import SwiftUI

struct MeditationTipsView: View {
    private let tips = [
        "meditation.tip.breathing",
        "meditation.tip.posture",
        "meditation.tip.focus",
        "meditation.tip.patience"
    ]
    
    @State private var currentTipIndex = 0
    
    var body: some View {
        VStack(spacing: 12) {
            Text("meditation.tips.title")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(LocalizedStringKey(tips[currentTipIndex]))
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
