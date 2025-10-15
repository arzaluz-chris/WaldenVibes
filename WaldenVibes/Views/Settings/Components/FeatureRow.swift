// WaldenVibes/Views/Settings/Components/FeatureRow.swift
import SwiftUI

struct FeatureRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary.opacity(0.9))
            }
            .padding(12)
            .background(.thinMaterial)
            .cornerRadius(12)

        } else {
            // MARK: - iOS 18 Design
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40)
                
                Text(title)
                    .font(.subheadline)
            }
        }
    }
}
