// MoreView.swift - Fixed
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
                    
                    Text("Your emotional well-being companion")
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
                    Text("Quick Overview")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        QuickStatCard(
                            icon: "heart.fill",
                            value: "\(dataManager.emotions.count)",
                            label: "Total Emotions",
                            color: Color("EmotionHappy")
                        )
                        
                        QuickStatCard(
                            icon: "star.fill",
                            value: "\(dataManager.moments.count)",
                            label: "Special Moments",
                            color: Color("EmotionExcited")
                        )
                        
                        QuickStatCard(
                            icon: "waveform.path.ecg",
                            value: String(format: "%.1f", dataManager.averageStressLevel(for: .month)),
                            label: "Avg Stress",
                            color: Color("StressModerate")
                        )
                        
                        QuickStatCard(
                            icon: "calendar",
                            value: "\(daysTracked)",
                            label: "Days Tracked",
                            color: Color("AccentColor")
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Menu Items
                VStack(spacing: 12) {
                    Text("Tools & Features")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    NavigationLink(destination: StatisticsView()) {
                        MenuRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Detailed Statistics",
                            subtitle: "View trends and insights",
                            color: .blue
                        )
                    }
                    
                    NavigationLink(destination: ExportView()) {
                        MenuRow(
                            icon: "square.and.arrow.up",
                            title: "Export Data",
                            subtitle: "Save your data externally",
                            color: .green
                        )
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        MenuRow(
                            icon: "gearshape.fill",
                            title: "Settings",
                            subtitle: "Customize your experience",
                            color: .gray
                        )
                    }
                    
                    Button(action: { showingAbout = true }) {
                        MenuRow(
                            icon: "info.circle.fill",
                            title: "About",
                            subtitle: "Learn more about the app",
                            color: .orange
                        )
                    }
                    
                    Button(action: { showingPrivacy = true }) {
                        MenuRow(
                            icon: "lock.shield.fill",
                            title: "Privacy",
                            subtitle: "Your data is safe",
                            color: .purple
                        )
                    }
                }
                
                // Motivational Quote
                VStack(spacing: 12) {
                    Text("Daily Inspiration")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("“The greatest wealth is health.”")
                        .font(.title3)
                        .italic()
                        .multilineTextAlignment(.center)
                    
                    Text("- Virgil")
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

