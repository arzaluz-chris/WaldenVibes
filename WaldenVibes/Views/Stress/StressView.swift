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
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color("StressLow").opacity(0.1),
                    Color("StressModerate").opacity(0.05),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            
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
                        // Add haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        showingAddStress = true
                    }) {
                        Label("Manual Entry", systemImage: "slider.horizontal.3")
                    }
                    
                    Button(action: {
                        // Add haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        showingStressTest = true
                    }) {
                        Label("Take Assessment", systemImage: "doc.text.magnifyingglass")
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color("AccentColor"))
                }
            }
        }
        .sheet(isPresented: $showingAddStress) {
            AddStressView()
        }
        .sheet(isPresented: $showingStressTest) {
            StressTestView()
        }
        .sheet(item: $selectedStress) { stress in
            StressDetailView(stress: stress)
        }
        .sheet(isPresented: $showingTips) {
            StressTipsView()
        }
        // Ensure the top bar has an opaque background while scrolling
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        // (Duplicate toolbarBackground calls removed)
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 80))
                .foregroundColor(Color("AccentColor").opacity(0.5))
            
            Text("No stress records", comment: "Empty state title when no stress has been tracked")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start tracking your stress levels to identify patterns and get personalized insights", comment: "Updated empty state subtitle encouraging user to track stress")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            VStack(spacing: 12) {
                Button(action: {
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showingStressTest = true
                }) {
                    Label("Take Quick Assessment", systemImage: "doc.text.magnifyingglass")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color("AccentColor"))
                        .cornerRadius(25)
                }
                
                Button(action: {
                    // Add haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    showingAddStress = true
                }) {
                    Text("Manual Entry", comment: "Alternative option for manual stress entry")
                        .font(.subheadline)
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .padding(.top, 10)
        }
    }
}

