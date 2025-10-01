// WaldenVibes/Views/Main/ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var meditationManager = MeditationManager()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var navigationPath = NavigationPath()
    
    init() {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Tab Bar Configuration
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithTransparentBackground()
            tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            if horizontalSizeClass == .regular {
                // iPad: Full screen views with custom navigation
                NavigationStack(path: $navigationPath) {
                    iPadHomeView(selectedTab: $selectedTab)
                        .navigationDestination(for: Int.self) { tab in
                            destinationView(for: tab)
                        }
                }
            } else {
                // iPhone: Standard tab bar
                TabView(selection: $selectedTab) {
                    tabItem(view: EmotionsView(), tag: 0, title: "Emotions", icon: "heart.fill")
                    tabItem(view: MeditationView().environmentObject(meditationManager), tag: 1, title: "Meditation", icon: "sparkles")
                    tabItem(view: MomentsView(), tag: 2, title: "Moments", icon: "star.fill")
                    tabItem(view: StressView(), tag: 3, title: "Stress", icon: "waveform.path.ecg")
                    tabItem(view: MoreView(), tag: 4, title: "Tools", icon: "wrench.and.screwdriver.fill")
                }
                .accentColor(Color("AccentColor"))
                .onChange(of: selectedTab) { _, _ in
                    let selectionFeedback = UISelectionFeedbackGenerator()
                    selectionFeedback.selectionChanged()
                }
            }
        } else {
            // MARK: - iOS 18 Design
            if horizontalSizeClass == .regular {
                // iPad: Full screen views with custom navigation
                NavigationStack(path: $navigationPath) {
                    iPadHomeView(selectedTab: $selectedTab)
                        .navigationDestination(for: Int.self) { tab in
                            switch tab {
                            case 0: EmotionsView().navigationBarBackButtonHidden(false)
                            case 1: MeditationView().environmentObject(meditationManager).navigationBarBackButtonHidden(false)
                            case 2: MomentsView().navigationBarBackButtonHidden(false)
                            case 3: StressView().navigationBarBackButtonHidden(false)
                            case 4: MoreView().navigationBarBackButtonHidden(false)
                            default: EmotionsView()
                            }
                        }
                }
            } else {
                // iPhone: Standard tab bar
                TabView(selection: $selectedTab) {
                    NavigationView { EmotionsView() }.tabItem { Label(LocalizedStringKey("Emotions"), systemImage: "heart.fill") }.tag(0)
                    NavigationView { MeditationView().environmentObject(meditationManager) }.tabItem { Label(LocalizedStringKey("Meditation"), systemImage: "sparkles") }.tag(1)
                    NavigationView { MomentsView() }.tabItem { Label(LocalizedStringKey("Moments"), systemImage: "star.fill") }.tag(2)
                    NavigationView { StressView() }.tabItem { Label(LocalizedStringKey("Stress"), systemImage: "waveform.path.ecg") }.tag(3)
                    NavigationView { MoreView() }.tabItem { Label(LocalizedStringKey("Tools"), systemImage: "wrench.and.screwdriver.fill") }.tag(4)
                }
                .accentColor(Color("AccentColor"))
                .onChange(of: selectedTab) { _, _ in
                    let selectionFeedback = UISelectionFeedbackGenerator()
                    selectionFeedback.selectionChanged()
                }
            }
        }
    }

    // Helper function for iOS 26+ iPhone tab items
    @available(iOS 26.0, *)
    private func tabItem<V: View>(view: V, tag: Int, title: LocalizedStringKey, icon: String) -> some View {
        NavigationView {
            view
                .navigationBarTitleDisplayMode(.inline) // Ensures consistency
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
        .tabItem { Label(title, systemImage: icon) }
        .tag(tag)
    }

    // Helper function for iOS 26+ iPad navigation destinations
    @available(iOS 26.0, *)
    @ViewBuilder
    private func destinationView(for tab: Int) -> some View {
        switch tab {
        case 0: EmotionsView()
        case 1: MeditationView().environmentObject(meditationManager)
        case 2: MomentsView()
        case 3: StressView()
        case 4: MoreView()
        default: EmotionsView()
        }
    }
}

// MARK: - iPad Home View
struct iPadHomeView: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        (0, LocalizedStringKey("Emotions"), "heart.fill", Color("EmotionHappy")),
        (1, LocalizedStringKey("Meditation"), "sparkles", Color("AccentColor")),
        (2, LocalizedStringKey("Moments"), "star.fill", Color("EmotionExcited")),
        (3, LocalizedStringKey("Stress"), "waveform.path.ecg", Color("StressModerate")),
        (4, LocalizedStringKey("Tools"), "wrench.and.screwdriver.fill", Color.gray)
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                AnimatedGlassBackground(color: .purple)
                
                ScrollView {
                    VStack(spacing: 40) {
                        header
                        
                        // Navigation Grid
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(tabs, id: \.0) { tab in
                                NavigationLink(value: tab.0) {
                                    gridCell(tab: tab)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)

        } else {
            // MARK: - iOS 18 Design
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 16) {
                    Image("LaunchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text(LocalizedStringKey("Walden Vibes"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(LocalizedStringKey("Select where you want to go"))
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                
                // Navigation Grid
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(tabs, id: \.0) { tab in
                        NavigationLink(value: tab.0) {
                            VStack(spacing: 16) {
                                Image(systemName: tab.2)
                                    .font(.system(size: 50))
                                    .foregroundColor(tab.3)
                                
                                Text(tab.1)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 200, height: 150)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .shadow(radius: 5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    // Header for iOS 26+ iPad View
    @available(iOS 26.0, *)
    private var header: some View {
        VStack(spacing: 16) {
            Image("LaunchLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .shadow(radius: 10)
            
            Text(LocalizedStringKey("Walden Vibes"))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(LocalizedStringKey("Select where you want to go"))
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding(.top, 60)
    }

    // Grid Cell for iOS 26+ iPad View
    @available(iOS 26.0, *)
    private func gridCell(tab: (Int, LocalizedStringKey, String, Color)) -> some View {
        VStack(spacing: 16) {
            Image(systemName: tab.2)
                .font(.system(size: 50))
                .foregroundColor(tab.3)
                .shadow(color: tab.3.opacity(0.5), radius: 10)
            
            Text(tab.1)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(width: 200, height: 150)
        .background(.regularMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 15)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
    }
}
