// WaldenVibes/Views/Stress/Components/StressCard.swift
import SwiftUI

struct StressCard: View {
    let stress: Stress
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            HStack(spacing: 16) {
                // Stress Level Indicator
                VStack {
                    Text(stress.stressEmoji)
                        .font(.title)

                    Text("\(Int(stress.level))")
                        .font(.headline)
                        .foregroundColor(stress.stressColor)
                }
                .frame(width: 60)
                .padding(8)
                .background(
                    Circle()
                        .fill(stress.stressColor.opacity(0.15))
                        .shadow(color: stress.stressColor.opacity(0.3), radius: 8, y: 4)
                )

                // Details
                VStack(alignment: .leading, spacing: 6) {
                    Text(stress.stressDescription)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    if !stress.note.isEmpty {
                        Text(stress.note)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }

                    HStack {
                        Text(stress.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.tertiary)

                        Text("•")
                            .foregroundStyle(.tertiary)

                        Text(stress.date, style: .time)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.secondary.opacity(0.5))
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
            .padding(.horizontal)
        } else {
            // MARK: - iOS 18 Design
            HStack(spacing: 16) {
                // Stress Level Indicator
                VStack {
                    Text(stress.stressEmoji)
                        .font(.title)

                    Text("\(Int(stress.level))")
                        .font(.headline)
                        .foregroundColor(stress.stressColor)
                }
                .frame(width: 60)

                // Details
                VStack(alignment: .leading, spacing: 6) {
                    Text(stress.stressDescription)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    if !stress.note.isEmpty {
                        Text(stress.note)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }

                    HStack {
                        Text(stress.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.tertiary)

                        Text("•")
                            .foregroundStyle(.tertiary)

                        Text(stress.date, style: .time)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.secondary.opacity(0.5))
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
