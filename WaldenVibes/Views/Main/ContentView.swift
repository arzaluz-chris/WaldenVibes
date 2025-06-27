// ContentView.swift - Updated with redesigned More tab
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var meditationManager = MeditationManager()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Emotions Tab
            NavigationView {
                EmotionsView()
            }
            .tabItem {
                Label("tab.emotions", systemImage: "heart.fill")
            }
            .tag(0)
            
            // Meditation Tab
            NavigationView {
                MeditationView()
                    .environmentObject(meditationManager)
            }
            .tabItem {
                Label("tab.meditation", systemImage: "sparkles")
            }
            .tag(1)
            
            // Moments Tab
            NavigationView {
                MomentsView()
            }
            .tabItem {
                Label("tab.moments", systemImage: "star.fill")
            }
            .tag(2)
            
            // Stress Tab
            NavigationView {
                StressView()
            }
            .tabItem {
                Label("tab.stress", systemImage: "waveform.path.ecg")
            }
            .tag(3)
            
            // More Tab - Updated
            NavigationView {
                MoreView()
            }
            .tabItem {
                Label("More", systemImage: "ellipsis.circle.fill")
            }
            .tag(4)
        }
        .accentColor(Color("AccentColor"))
    }
}
