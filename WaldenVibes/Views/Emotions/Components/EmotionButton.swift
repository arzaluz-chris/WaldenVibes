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
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(isSelected ? type.color : .secondary)
                }
                .padding()
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(type.color.opacity(0.15))
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        }
                    }
                    .shadow(color: isSelected ? type.color.opacity(0.3) : .clear, radius: 10, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: isSelected ? [type.color.opacity(0.6), type.color.opacity(0.3)] : [.white.opacity(0.3), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                )
            }
            .buttonStyle(PlainButtonStyle())
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
