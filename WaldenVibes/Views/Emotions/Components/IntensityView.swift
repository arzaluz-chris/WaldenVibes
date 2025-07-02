// WaldenVibes/Views/Emotions/Components/IntensityView.swift
import SwiftUI

struct IntensityView: View {
    let intensity: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...10, id: \.self) { level in
                Circle()
                    .fill(level <= Int(intensity) ? color : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}
