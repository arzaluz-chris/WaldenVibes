// WaldenVibes/Views/Stress/Components/StressCard.swift
import SwiftUI

struct StressCard: View {
    let stress: Stress
    
    var body: some View {
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
