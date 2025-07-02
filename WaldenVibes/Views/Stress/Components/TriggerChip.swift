// WaldenVibes/Views/Stress/Components/TriggerChip.swift
import SwiftUI

struct TriggerChip: View {
    let trigger: StressTrigger
    
    var body: some View {
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
