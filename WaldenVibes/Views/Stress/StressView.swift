// WaldenVibes/Views/Stress/StressView.swift
import SwiftUI

struct StressView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddStress = false
    @State private var showingStressTest = false
    @State private var selectedStress: Stress?
    @State private var showingTips = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if #available(iOS 26.0, *) {
            // MARK: - iOS 26 Glassmorphism Design
            ZStack {
                AnimatedGlassBackground(color: Color("StressModerate"))
                
                if dataManager.stressRecords.isEmpty {
                    emptyStateView
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                } else {
                    StressList(
                        selectedStress: $selectedStress,
                        showingTips: $showingTips,
                        showingStressTest: $showingStressTest
                    )
                }
            }
            .navigationTitle("Stress")
            .toolbar { navigationToolbar }
            .sheet(isPresented: $showingAddStress) { AddStressView() }
            .sheet(isPresented: $showingStressTest) { StressTestView() }
            .sheet(item: $selectedStress) { stress in StressDetailView(stress: stress) }
            .sheet(isPresented: $showingTips) { StressTipsView() }

        } else {
            // MARK: - iOS 18 Design
            ZStack {
                LinearGradient(
                    colors: [Color("StressLow").opacity(0.1), Color("StressModerate").opacity(0.05), .clear],
                    startPoint: .top, endPoint: .center
                ).ignoresSafeArea()
                
                if dataManager.stressRecords.isEmpty {
                    emptyStateView
                        .frame(maxWidth: horizontalSizeClass == .regular ? 600 : .infinity)
                } else {
                    StressList(
                        selectedStress: $selectedStress,
                        showingTips: $showingTips,
                        showingStressTest: $showingStressTest
                    )
                }
            }
            .navigationTitle("Stress")
            .navigationBarTitleDisplayMode(horizontalSizeClass == .regular ? .large : .automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            showingAddStress = true
                        }) { Label("Manual Entry", systemImage: "slider.horizontal.3") }
                        
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            showingStressTest = true
                        }) { Label("Take Assessment", systemImage: "doc.text.magnifyingglass") }
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(Color("AccentColor"))
                    }
                }
            }
            .sheet(isPresented: $showingAddStress) { AddStressView() }
            .sheet(isPresented: $showingStressTest) { StressTestView() }
            .sheet(item: $selectedStress) { stress in StressDetailView(stress: stress) }
            .sheet(isPresented: $showingTips) { StressTipsView() }
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 80))
                .foregroundColor(Color("AccentColor").opacity(0.5))
            
            Text("No stress records", comment: "Empty state title when no stress has been tracked")
                .font(.title2).fontWeight(.semibold)
            
            Text("Start tracking your stress levels to identify patterns and get personalized insights", comment: "Updated empty state subtitle encouraging user to track stress")
                .font(.body).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal, 40)
            
            VStack(spacing: 12) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showingStressTest = true
                }) {
                    Label("Take Quick Assessment", systemImage: "doc.text.magnifyingglass")
                        .font(.headline).foregroundColor(.white).padding(.horizontal, 20).padding(.vertical, 12)
                        .background(Color("AccentColor")).cornerRadius(25)
                }
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showingAddStress = true
                }) {
                    Text("Manual Entry", comment: "Alternative option for manual stress entry")
                        .font(.subheadline).foregroundColor(Color("AccentColor"))
                }
            }.padding(.top, 10)
        }
    }

    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showingAddStress = true
                }) { Label("Manual Entry", systemImage: "slider.horizontal.3") }
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showingStressTest = true
                }) { Label("Take Assessment", systemImage: "doc.text.magnifyingglass") }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color("AccentColor"))
            }
        }
    }
}
