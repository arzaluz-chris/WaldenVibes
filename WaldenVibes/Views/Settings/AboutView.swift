// WaldenVibes/Views/Settings/AboutView.swift
import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // App Icon and Name
                    VStack(spacing: 16) {
                        Image("LaunchLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                        Text("Walden Vibes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Your emotional well-being matters", comment: "App tagline in about view")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Description
                    Text("Walden Vibes is designed to help you track your emotional well-being, practice mindfulness, and manage stress effectively.", comment: "App description in about view")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(
                            icon: "heart.fill",
                            title: String(localized: "Detailed emotion tracking", comment: "Feature description"),
                            color: Color("AccentColor")
                        )
                        
                        FeatureRow(
                            icon: "sparkles",
                            title: String(localized: "Customizable meditation timer", comment: "Feature description"),
                            color: .blue
                        )
                        
                        FeatureRow(
                            icon: "star.fill",
                            title: String(localized: "Capture special moments", comment: "Feature description"),
                            color: .orange
                        )
                        
                        FeatureRow(
                            icon: "waveform.path.ecg",
                            title: String(localized: "Stress monitoring and management", comment: "Feature description"),
                            color: .green
                        )
                        
                        FeatureRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: String(localized: "Detailed analysis and insights", comment: "Feature description"),
                            color: .red
                        )
                    }
                    .padding(.horizontal, 40)
                    
                    // Team Credits
                    VStack(spacing: 16) {
                        Text("Created by", comment: "Credits header")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 8) {
                            Text("Ubaldo Orozco Camargo")
                                .font(.subheadline)
                            Text("Patricio Aguilar Pacheco")
                                .font(.subheadline)
                            Text("Eduardo García Parra")
                                .font(.subheadline)
                            Text("Hansel Eduardo Ortega Borges")
                                .font(.subheadline)
                            Text("Santiago Aragoneses Arizmendi")
                                .font(.subheadline)
                        }
                        .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Footer
                    VStack(spacing: 8) {
                        Text("Made with ❤️ for your well-being", comment: "App credits message")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("© 2025 Walden Dos", comment: "Copyright notice")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
