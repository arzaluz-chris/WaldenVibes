//  FeatureRow.swift
import SwiftUI

struct FeatureRow: View {
    let icon: String
    let title: LocalizedStringKey
    let color: Color
    
    var body: some View {
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
