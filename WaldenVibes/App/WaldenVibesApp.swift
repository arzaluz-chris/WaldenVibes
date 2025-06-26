// WaldenVibesApp.swift
import SwiftUI

@main
struct WaldenVibesApp: App {
    @StateObject private var dataManager = DataManager.shared
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("selectedTheme") private var selectedTheme = "system"
    @AppStorage("appLanguage") private var appLanguage = "es"
    
    init() {
        // Configure app appearance
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environmentObject(dataManager)
                    .environment(\.locale, Locale(identifier: appLanguage))
                    .preferredColorScheme(colorScheme)
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environment(\.locale, Locale(identifier: appLanguage))
                    .preferredColorScheme(colorScheme)
            }
        }
    }
    
    private var colorScheme: ColorScheme? {
        switch selectedTheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
    
    private func configureAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
