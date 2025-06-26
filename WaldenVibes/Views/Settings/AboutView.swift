//  AboutView.swift
import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // App Icon and Name
                    VStack(spacing: 16) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 80))
                            .foregroundColor(Color("AccentColor"))
                        
                        Text("Walden Vibes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("about.tagline")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Description
                    Text("about.description")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(
                            icon: "heart.fill",
                            title: "about.feature.emotions",
                            color: Color("AccentColor")
                        )
                        
                        FeatureRow(
                            icon: "sparkles",
                            title: "about.feature.meditation",
                            color: .blue
                        )
                        
                        FeatureRow(
                            icon: "star.fill",
                            title: "about.feature.moments",
                            color: .orange
                        )
                        
                        FeatureRow(
                            icon: "waveform.path.ecg",
                            title: "about.feature.stress",
                            color: .green
                        )
                        
                        FeatureRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "about.feature.statistics",
                            color: .red
                        )
                    }
                    .padding(.horizontal, 40)
                    
                    // Credits
                    VStack(spacing: 8) {
                        Text("about.credits")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("about.credits.team")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 40)
                }
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
