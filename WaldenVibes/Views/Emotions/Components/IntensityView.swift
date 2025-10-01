// WaldenVibes/Views/Emotions/Components/IntensityView.swift
import SwiftUI

struct IntensityView: View {
    let intensity: Double
    let color: Color
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            HStack(spacing: 5) {
                ForEach(1...10, id: \.self) { level in
                    let isFilled = level <= Int(intensity)
                    Circle()
                        .fill(isFilled ? color : Color.gray.opacity(0.15))
                        .frame(width: 10, height: 10)
                        .overlay(
                            // Add an inner glow for filled circles
                            Circle()
                                .stroke(isFilled ? .white.opacity(0.5) : .clear, lineWidth: 1)
                                .blur(radius: 1)
                        )
                        .shadow(color: isFilled ? color.opacity(0.3) : .clear, radius: 5)
                        .animation(.spring(), value: intensity)
                }
            }
            
        } else {
            // MARK: - iOS 18 Design
            HStack(spacing: 4) {
                ForEach(1...10, id: \.self) { level in
                    Circle()
                        .fill(level <= Int(intensity) ? color : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}
