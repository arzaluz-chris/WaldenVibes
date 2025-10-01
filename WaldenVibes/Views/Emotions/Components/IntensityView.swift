// WaldenVibes/Views/Emotions/Components/IntensityView.swift
import SwiftUI

struct IntensityView: View {
    let intensity: Double
    let color: Color
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            HStack(spacing: 4) {
                ForEach(1...10, id: \.self) { level in
                    Circle()
                        .fill(level <= Int(intensity) ? color : Color.gray.opacity(0.2))
                        .frame(width: 8, height: 8)
                        .shadow(color: level <= Int(intensity) ? color.opacity(0.4) : .clear, radius: 3, y: 1)
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
