// WaldenVibes/Views/Main/MoreView.swift
import SwiftUI

struct MoreView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingExport = false
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Card
                VStack(spacing: 16) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color("AccentColor"))
                    
                    Text("Walden Vibes")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Your emotional well-being companion", comment: "App tagline in More view")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("AccentColor").opacity(0.1))
                )
                .padding(.horizontal)
                
                // Quick Stats
                VStack(spacing: 16) {
                    Text("Quick Overview", comment: "Section header for statistics overview")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        QuickStatCard(
                            icon: "heart.fill",
                            value: "\(dataManager.emotions.count)",
                            label: String(localized: "Total Emotions", comment: "Quick stat label"),
                            color: Color("EmotionHappy")
                        )
                        
                        QuickStatCard(
                            icon: "star.fill",
                            value: "\(dataManager.moments.count)",
                            label: String(localized: "Special Moments", comment: "Quick stat label"),
                            color: Color("EmotionExcited")
                        )
                        
                        QuickStatCard(
                            icon: "waveform.path.ecg",
                            value: String(format: "%.1f", dataManager.averageStressLevel(for: .month)),
                            label: String(localized: "Avg Stress", comment: "Quick stat label"),
                            color: Color("StressModerate")
                        )
                        
                        QuickStatCard(
                            icon: "calendar",
                            value: "\(daysTracked)",
                            label: String(localized: "Days Tracked", comment: "Quick stat label"),
                            color: Color("AccentColor")
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Menu Items
                VStack(spacing: 12) {
                    Text("Tools & Features", comment: "Section header for tools menu")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    NavigationLink(destination: StatisticsView()) {
                        MenuRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: String(localized: "Detailed Statistics", comment: "Menu item"),
                            subtitle: String(localized: "View trends and insights", comment: "Menu item subtitle"),
                            color: .blue
                        )
                    }
                    
                    NavigationLink(destination: ExportView()) {
                        MenuRow(
                            icon: "square.and.arrow.up",
                            title: String(localized: "Export Data", comment: "Menu item"),
                            subtitle: String(localized: "Save your data externally", comment: "Menu item subtitle"),
                            color: .green
                        )
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        MenuRow(
                            icon: "gearshape.fill",
                            title: String(localized: "Settings", comment: "Menu item"),
                            subtitle: String(localized: "Customize your experience", comment: "Menu item subtitle"),
                            color: .gray
                        )
                    }
                    
                    Button(action: { showingAbout = true }) {
                        MenuRow(
                            icon: "info.circle.fill",
                            title: String(localized: "About", comment: "Menu item"),
                            subtitle: String(localized: "Learn more about the app", comment: "Menu item subtitle"),
                            color: .orange
                        )
                    }
                    
                    Button(action: { showingPrivacy = true }) {
                        MenuRow(
                            icon: "lock.shield.fill",
                            title: String(localized: "Privacy", comment: "Menu item"),
                            subtitle: String(localized: "Your data is safe", comment: "Menu item subtitle"),
                            color: .purple
                        )
                    }
                }
                
                // Motivational Quote
                VStack(spacing: 12) {
                    Text("Daily Inspiration", comment: "Section header for inspirational quote")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\"The greatest wealth is health.\"", comment: "Inspirational quote")
                        .font(.title3)
                        .italic()
                        .multilineTextAlignment(.center)
                    
                    Text("- Virgil", comment: "Quote author")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .padding(.horizontal)
                
                Spacer(minLength: 30)
            }
            .padding(.vertical)
        }
        .navigationTitle("More")
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyView()
        }
    }
    
    private var daysTracked: Int {
        let calendar = Calendar.current
        let dates = Set(dataManager.emotions.map { calendar.startOfDay(for: $0.date) })
        return dates.count
    }
}
