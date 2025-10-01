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
                    .foregroundColor(isSelected ? .white : .primary.opacity(0.8))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            // Conditional material background
                            if isSelected {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(color.opacity(0.5))
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(20)
                            } else {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(color.opacity(0.1))
                                    .background(.thinMaterial)
                                    .cornerRadius(20)
                            }
                        }
                    )
                    .overlay(
                        // Luminous border
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(LinearGradient(
                                colors: [
                                    .white.opacity(isSelected ? 0.6 : 0.3),
                                    .white.opacity(isSelected ? 0.2 : 0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20)) // Clip to ensure overlay respects corner radius
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)

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
