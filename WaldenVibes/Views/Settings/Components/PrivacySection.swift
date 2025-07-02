// WaldenVibes/Views/Settings/Components/PrivacySection.swift
import SwiftUI

struct PrivacySection: View {
    let title: LocalizedStringKey
    let content: LocalizedStringKey
    
    var body: some View {
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
