// WaldenVibes/Views/Main/MoreView.swift
import SwiftUI

struct MoreView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingExport = false
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                AnimatedGlassBackground(color: Color("AccentColor"))

                ScrollView {
                    VStack(spacing: 24) {
                        // Header Card
                        VStack(spacing: 16) {
                            Image("LaunchLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)

                            Text("Walden Vibes")
                                .font(.title)
                                .fontWeight(.bold)

                            Text("Your emotional well-being companion", comment: "App tagline in More view")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 30)
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .cornerRadius(20)
                        .shadow(color: Color("AccentColor").opacity(0.2), radius: 15, y: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(LinearGradient(
                                    colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                
                // Quick Stats
                VStack(spacing: 16) {
                    Text("Quick Overview", comment: "Section header for statistics overview")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    if horizontalSizeClass == .regular {
                        // iPad: 4 columns
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                            quickStatCards
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: 800)
                    } else {
                        // iPhone: 2 columns
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            quickStatCards
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Menu Items
                VStack(spacing: 12) {
                    Text("Tools & Features", comment: "Section header for tools menu")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    VStack(spacing: 12) {
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
                    .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
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
                        .background(.thinMaterial)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(LinearGradient(
                                    colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)

                        Spacer(minLength: 30)
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Tools")
            .navigationBarTitleDisplayMode(horizontalSizeClass == .regular ? .large : .automatic)
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .sheet(isPresented: $showingPrivacy) {
                PrivacyView()
            }
        } else {
            // MARK: - iOS 18 Design
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    VStack(spacing: 16) {
                        Image("LaunchLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)

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
                    .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)

                    // Quick Stats
                    VStack(spacing: 16) {
                        Text("Quick Overview", comment: "Section header for statistics overview")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        if horizontalSizeClass == .regular {
                            // iPad: 4 columns
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                                quickStatCards
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: 800)
                        } else {
                            // iPhone: 2 columns
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                quickStatCards
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Menu Items
                    VStack(spacing: 12) {
                        Text("Tools & Features", comment: "Section header for tools menu")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 8)

                        VStack(spacing: 12) {
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
                        .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
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
                    .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)

                    Spacer(minLength: 30)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Tools")
            .navigationBarTitleDisplayMode(horizontalSizeClass == .regular ? .large : .automatic)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .sheet(isPresented: $showingPrivacy) {
                PrivacyView()
            }
        }
    }
    
    @ViewBuilder
    private var quickStatCards: some View {
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
           
           private var daysTracked: Int {
               let calendar = Calendar.current
               let dates = Set(dataManager.emotions.map { calendar.startOfDay(for: $0.date) })
               return dates.count
           }
        }
