//  CurrentStressCard.swift
import SwiftUI

struct CurrentStressCard: View {
    let stress: Stress
    
    var body: some View {
        VStack(spacing: 16) {
            Text("stress.current")
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
