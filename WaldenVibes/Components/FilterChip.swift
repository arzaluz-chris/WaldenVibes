// WaldenVibes/Components/FilterChip.swift
import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            Button(action: action) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .white : color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            if isSelected {
                                Capsule()
                                    .fill(color)
                            } else {
                                Capsule()
                                    .fill(.thinMaterial)
                            }
                        }
                        .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 8, y: 4)
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: isSelected ? [.white.opacity(0.5), .white.opacity(0.1)] : [color.opacity(0.3), color.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    )
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            // MARK: - iOS 18 Design
            Button(action: action) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .white : color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isSelected ? color : color.opacity(0.1))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
