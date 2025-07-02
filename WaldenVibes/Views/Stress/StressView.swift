// WaldenVibes/Views/Stress/StressView.swift
import SwiftUI

struct StressView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddStress = false
    @State private var selectedStress: Stress?
    @State private var showingTips = false
    
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
                EmptyStressView(showingAddStress: $showingAddStress)
            } else {
                StressList(selectedStress: $selectedStress, showingTips: $showingTips)
            }
        }
        .navigationTitle("Stress")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showingTips = true }) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddStress = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color("AccentColor"))
                }
            }
        }
        .sheet(isPresented: $showingAddStress) {
            AddStressView()
        }
        .sheet(item: $selectedStress) { stress in
            StressDetailView(stress: stress)
        }
        .sheet(isPresented: $showingTips) {
            StressTipsView()
        }
    }
}

// MARK: - Empty State
struct EmptyStressView: View {
    @Binding var showingAddStress: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("EmptyStress")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .opacity(0.5)
            
            Text("No stress records", comment: "Empty state title when no stress has been tracked")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start tracking your stress levels to identify patterns", comment: "Empty state subtitle encouraging user to track stress")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: { showingAddStress = true }) {
                Label("Record Stress", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color("AccentColor"))
                    .cornerRadius(25)
            }
            .padding(.top, 10)
        }
    }
}
