// WaldenVibes/App/WaldenVibesApp.swift
import SwiftUI
import AVFoundation
import UserNotifications

@main
struct WaldenVibesApp: App {
    @StateObject private var dataManager = DataManager.shared
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("selectedTheme") private var selectedTheme = "system"
    @AppStorage("appLanguage") private var appLanguage = "es"
    @State private var isShowingSplash = true
    
    init() {
        // Configure app appearance
        configureAppearance()
        
        // Configure audio session for background playback
        configureAudioSession()
        
        // Request notification permissions
        requestNotificationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            if isShowingSplash {
                SplashView(isShowingSplash: $isShowingSplash)
            } else if hasSeenOnboarding {
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
    
    private func configureAudioSession() {
        do {
            // Configure audio session for background playback and to override silent mode
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.allowBluetooth, .allowBluetoothA2DP, .allowAirPlay]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Notification permissions granted")
                } else {
                    print("❌ Notification permissions denied")
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
