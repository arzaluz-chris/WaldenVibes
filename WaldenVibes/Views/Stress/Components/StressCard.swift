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
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
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
