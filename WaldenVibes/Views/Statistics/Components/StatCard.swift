// WaldenVibes/Views/Statistics/Components/StatCard.swift
import SwiftUI

struct StatCard: View {
    let title: LocalizedStringKey
    let value: String
    var subtitle: String? = nil
    let icon: String
    let color: Color
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(color.opacity(0.15))
                                .shadow(color: color.opacity(0.3), radius: 6, y: 3)
                        )
                    Spacer()
                }

                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.08), radius: 10, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        } else {
            // MARK: - iOS 18 Design
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                    Spacer()
                }

                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
        }
    }
}
