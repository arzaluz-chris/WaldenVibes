// WaldenVibes/Views/Stress/Components/CurrentStressCard.swift
import SwiftUI

struct CurrentStressCard: View {
    let stress: Stress
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(spacing: 16) {
                Text("Current Stress Level", comment: "Current stress card title")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                // Stress Meter
                ZStack {
                    // Background
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 36)

                        // Filled portion
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color("StressLow"),
                                        Color("StressModerate"),
                                        Color("StressHigh"),
                                        Color("StressVeryHigh")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (stress.level / 10), height: 36)
                            .shadow(color: stress.stressColor.opacity(0.4), radius: 8, y: 4)
                    }
                    .frame(height: 36)

                    // Level text
                    Text("\(Int(stress.level))/10")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                }

                HStack {
                    Text(stress.stressEmoji)
                        .font(.largeTitle)

                    Text(stress.stressDescription)
                        .font(.headline)
                        .foregroundColor(stress.stressColor)
                }

                if !stress.triggers.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(stress.triggers, id: \.self) { trigger in
                                TriggerChip(trigger: trigger)
                            }
                        }
                    }
                }
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
            VStack(spacing: 16) {
                Text("Current Stress Level", comment: "Current stress card title")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Stress Meter
                ZStack {
                    // Background
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 30)

                        // Filled portion
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color("StressLow"),
                                        Color("StressModerate"),
                                        Color("StressHigh"),
                                        Color("StressVeryHigh")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (stress.level / 10), height: 30)
                    }
                    .frame(height: 30)

                    // Level text
                    Text("\(Int(stress.level))/10")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                HStack {
                    Text(stress.stressEmoji)
                        .font(.largeTitle)

                    Text(stress.stressDescription)
                        .font(.headline)
                        .foregroundColor(stress.stressColor)
                }

                if !stress.triggers.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(stress.triggers, id: \.self) { trigger in
                                TriggerChip(trigger: trigger)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}
