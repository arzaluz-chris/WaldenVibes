// WaldenVibes/Views/Stress/Components/TriggerChip.swift
import SwiftUI

struct TriggerChip: View {
    let trigger: StressTrigger
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            HStack(spacing: 4) {
                Image(systemName: trigger.icon)
                    .font(.caption)
                Text(trigger.localizedName)
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
            )
        } else {
            // MARK: - iOS 18 Design
            HStack(spacing: 4) {
                Image(systemName: trigger.icon)
                    .font(.caption)
                Text(trigger.localizedName)
                    .font(.caption)
            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
        }
    }
}
