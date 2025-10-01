// WaldenVibes/Views/Stress/Components/CurrentStressCard.swift
import SwiftUI

struct CurrentStressCard: View {
    let stress: Stress
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(spacing: 20) {
                Text("Current Stress Level", comment: "Current stress card title")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Stress Meter
                ZStack {
                    // Background
                    GeometryReader { geometry in
                        let gradient = LinearGradient(
                            colors: [
                                Color("StressLow"),
                                Color("StressModerate"),
                                Color("StressHigh"),
                                Color("StressVeryHigh")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        
                        // Track
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(0.1))
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(height: 30)

                        // Filled portion
                        RoundedRectangle(cornerRadius: 10)
                            .fill(gradient)
                            .frame(width: geometry.size.width * (stress.level / 10), height: 30)
                            .shadow(color: stress.stressColor.opacity(0.3), radius: 8, y: 4)
                    }
                    .frame(height: 30)
                    
                    // Level text
                    Text("\(Int(stress.level))/10")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
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
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
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
