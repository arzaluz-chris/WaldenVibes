// WaldenVibes/Views/Emotions/Components/EmotionCard.swift
import SwiftUI

struct EmotionCard: View {
    let emotion: Emotion
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            HStack(spacing: 16) {
                // Emoji with background
                ZStack {
                    Circle()
                        .fill(emotion.type.color.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())

                    Text(emotion.type.emoji)
                        .font(.system(size: 30))
                }
                
                // Details
                VStack(alignment: .leading, spacing: 6) {
                    // Type and intensity
                    HStack {
                        Text(emotion.type.localizedName)
                            .font(.headline)
                        
                        Spacer()
                        
                        IntensityView(intensity: emotion.intensity, color: emotion.type.color)
                    }
                    
                    // Note preview
                    if !emotion.note.isEmpty {
                        Text(emotion.note)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    // Time and Location
                    HStack {
                        Text(emotion.date, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let location = emotion.location {
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(location)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(20)
            .shadow(color: emotion.type.color.opacity(0.1), radius: 15, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(LinearGradient(
                        colors: [.white.opacity(0.5), .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
            .padding(.horizontal)

        } else {
            // MARK: - iOS 18 Design
            HStack(spacing: 16) {
                // Emoji with background
                ZStack {
                    Circle()
                        .fill(emotion.type.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(emotion.type.emoji)
                        .font(.system(size: 30))
                }
                
                // Details
                VStack(alignment: .leading, spacing: 6) {
                    // Type and intensity
                    HStack {
                        Text(emotion.type.localizedName)
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            ForEach(1...10, id: \.self) { level in
                                Rectangle()
                                    .fill(level <= Int(emotion.intensity) ? emotion.type.color : Color.gray.opacity(0.3))
                                    .frame(width: 3, height: 12)
                            }
                        }
                    }
                    
                    // Note preview
                    if !emotion.note.isEmpty {
                        Text(emotion.note)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    // Time and Location
                    HStack {
                        Text(emotion.date, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let location = emotion.location {
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(location)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .shadow(color: emotion.type.color.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)
        }
    }
}
