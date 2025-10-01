// WaldenVibes/Views/Emotions/Components/EmotionButton.swift
import SwiftUI

struct EmotionButton: View {
    let type: EmotionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            Button(action: action) {
                VStack(spacing: 8) {
                    Text(type.emoji)
                        .font(.system(size: 40))
                    
                    Text(type.localizedName)
                        .font(.caption)
                        .foregroundColor(isSelected ? .primary : .secondary)
                }
                .padding()
                .frame(minWidth: 80)
                .background(
                    ZStack {
                        // Use a material background that adapts to light/dark mode
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                        
                        // Add a colored glow when selected
                        if isSelected {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(type.color.opacity(0.3))
                                .blur(radius: 15)
                        }
                    }
                )
                .overlay(
                    // Luminous border, more prominent when selected
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(
                            colors: isSelected ?
                                [.white.opacity(0.8), type.color.opacity(0.5)] :
                                [.white.opacity(0.3), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: isSelected ? 2 : 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: isSelected ? type.color.opacity(0.15) : .black.opacity(0.05), radius: 10, y: 5)
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)

        } else {
            // MARK: - iOS 18 Design
            Button(action: action) {
                VStack(spacing: 8) {
                    Text(type.emoji)
                        .font(.system(size: 40))
                    
                    Text(type.localizedName)
                        .font(.caption)
                        .foregroundColor(isSelected ? type.color : .secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? type.color.opacity(0.2) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? type.color : Color.clear, lineWidth: 2)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
