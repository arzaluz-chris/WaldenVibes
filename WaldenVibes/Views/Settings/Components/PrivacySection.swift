// WaldenVibes/Views/Settings/Components/PrivacySection.swift
import SwiftUI

struct PrivacySection: View {
    let title: LocalizedStringKey
    let content: LocalizedStringKey
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)

        } else {
            // MARK: - iOS 18 Design
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
