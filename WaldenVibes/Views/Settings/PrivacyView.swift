// WaldenVibes/Views/Settings/PrivacyView.swift
import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            NavigationView {
                ZStack {
                    AnimatedGlassBackground(color: .blue).ignoresSafeArea()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Privacy Policy", comment: "Privacy policy title")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding([.top, .horizontal])
                            
                            Group {
                                PrivacySection(
                                    title: LocalizedStringKey("Your Data"),
                                    content: LocalizedStringKey("All your emotional data, moments, and stress records are stored locally on your device. We do not collect or have access to any of your personal information.")
                                )
                                
                                PrivacySection(
                                    title: LocalizedStringKey("Data Storage"),
                                    content: LocalizedStringKey("Your data is stored securely on your device using iOS's built-in security features. No data is transmitted to external servers.")
                                )
                                
                                PrivacySection(
                                    title: LocalizedStringKey("Data Sharing"),
                                    content: LocalizedStringKey("We never share, sell, or transmit your personal data to third parties. Your information remains completely private.")
                                )
                                
                                PrivacySection(
                                    title: LocalizedStringKey("Analytics"),
                                    content: LocalizedStringKey("We do not collect any analytics or usage data. Your app usage patterns remain private.")
                                )
                                
                                PrivacySection(
                                    title: LocalizedStringKey("Your Rights"),
                                    content: LocalizedStringKey("You have complete control over your data. You can export or delete all your data at any time from the settings menu.")
                                )
                            }
                            .padding(.horizontal)
                            
                            Text("Last updated: June 2025", comment: "Privacy policy last update date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding([.top, .horizontal])
                        }
                        .padding(.bottom, 40)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") { dismiss() }
                        }
                    }
                }
            }

        } else {
            // MARK: - iOS 18 Design
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Privacy Policy", comment: "Privacy policy title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Group {
                            PrivacySection(
                                title: LocalizedStringKey("Your Data"),
                                content: LocalizedStringKey("All your emotional data, moments, and stress records are stored locally on your device. We do not collect or have access to any of your personal information.")
                            )
                            
                            PrivacySection(
                                title: LocalizedStringKey("Data Storage"),
                                content: LocalizedStringKey("Your data is stored securely on your device using iOS's built-in security features. No data is transmitted to external servers.")
                            )
                            
                            PrivacySection(
                                title: LocalizedStringKey("Data Sharing"),
                                content: LocalizedStringKey("We never share, sell, or transmit your personal data to third parties. Your information remains completely private.")
                            )
                            
                            PrivacySection(
                                title: LocalizedStringKey("Analytics"),
                                content: LocalizedStringKey("We do not collect any analytics or usage data. Your app usage patterns remain private.")
                            )
                            
                            PrivacySection(
                                title: LocalizedStringKey("Your Rights"),
                                content: LocalizedStringKey("You have complete control over your data. You can export or delete all your data at any time from the settings menu.")
                            )
                        }
                        
                        Text("Last updated: June 2025", comment: "Privacy policy last update date")
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
                        Button("Done") { dismiss() }
                    }
                }
            }
        }
    }
}
