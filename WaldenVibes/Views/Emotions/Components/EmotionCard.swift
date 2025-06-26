//  EmotionCard.swift
import SwiftUI

struct EmotionCard: View {
    let emotion: Emotion
    
    var body: some View {
        HStack(spacing: 16) {
            // Emoji and Type
            VStack(spacing: 4) {
                Text(emotion.type.emoji)
                    .font(.system(size: 40))
                
                Text(emotion.type.localizedName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 70)
            
            // Details
            VStack(alignment: .leading, spacing: 6) {
                // Intensity
                HStack {
                    Text("intensity.label")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    IntensityView(intensity: emotion.intensity, color: emotion.type.color)
                }
                
                // Note preview
                if !emotion.note.isEmpty {
                    Text(emotion.note)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                // Time and Location
                HStack {
                    Text(emotion.date, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let location = emotion.location {
                        Text("• \(location)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(
            ZStack {
                Color(UIColor.secondarySystemBackground)
                Image("CardTexture")
                    .resizable()
                    .opacity(0.03)
            }
        )
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
