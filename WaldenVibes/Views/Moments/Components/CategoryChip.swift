// WaldenVibes/Views/Moments/Components/CategoryChip.swift
import SwiftUI

struct CategoryChip: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.caption)
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .regular)
                }
                .foregroundColor(isSelected ? .white : .primary.opacity(0.9))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(color.opacity(0.6))
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
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(LinearGradient(
                            colors: [
                                .white.opacity(isSelected ? 0.7 : 0.4),
                                .white.opacity(isSelected ? 0.3 : 0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ), lineWidth: 1.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: isSelected ? color.opacity(0.2) : .black.opacity(0.05), radius: 8, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)

        } else {
            // MARK: - iOS 18 Design
            Button(action: action) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.caption)
                    Text(title)
                        .font(.subheadline)
                }
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
