//  EmotionButton.swift
import SwiftUI

struct EmotionButton: View {
    let type: EmotionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(type.emoji)
                    .font(.system(size: 40))
                
                Text(type.localizedName)
                    .font(.caption)
                    .foregroundColor(isSelected ? type.color : .secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? type.color.opacity(0.2) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? type.color : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
