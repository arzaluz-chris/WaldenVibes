//  PrivacyView.swift
import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("privacy.title")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Group {
                        PrivacySection(
                            title: "privacy.section.data",
                            content: "privacy.section.data.content"
                        )
                        
                        PrivacySection(
                            title: "privacy.section.storage",
                            content: "privacy.section.storage.content"
                        )
                        
                        PrivacySection(
                            title: "privacy.section.sharing",
                            content: "privacy.section.sharing.content"
                        )
                        
                        PrivacySection(
                            title: "privacy.section.analytics",
                            content: "privacy.section.analytics.content"
                        )
                        
                        PrivacySection(
                            title: "privacy.section.rights",
                            content: "privacy.section.rights.content"
                        )
                    }
                    
                    Text("privacy.update.date")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
