//  ContentView.swift
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
            
            // Statistics Tab
            NavigationView {
                StatisticsView()
            }
            .tabItem {
                Label("tab.statistics", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(4)
            
            // Settings Tab
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("tab.settings", systemImage: "gearshape.fill")
            }
            .tag(5)
        }
        .accentColor(Color("AccentColor"))
    }
}
