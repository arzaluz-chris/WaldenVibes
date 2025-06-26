//  StressView.swift
import SwiftUI

struct StressView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddStress = false
    @State private var selectedStress: Stress?
    @State private var showingTips = false
    
    var body: some View {
        ZStack {
            if dataManager.stressRecords.isEmpty {
                EmptyStressView(showingAddStress: $showingAddStress)
            } else {
                StressList(selectedStress: $selectedStress)
            }
        }
        .navigationTitle("nav.stress")
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
            
            Text("stress.empty.title")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("stress.empty.subtitle")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: { showingAddStress = true }) {
                Label("stress.add", systemImage: "plus.circle.fill")
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

// MARK: - Stress List
struct StressList: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedStress: Stress?
    
    var body: some View {
        ScrollView {
            // Current Stress Summary
            if let latestStress = dataManager.stressRecords.first {
                CurrentStressCard(stress: latestStress)
                    .padding(.horizontal)
                    .padding(.top)
            }
            
            // History
            LazyVStack(spacing: 12) {
                Text("stress.history")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                ForEach(dataManager.stressRecords) { stress in
                    StressCard(stress: stress)
                        .onTapGesture {
                            selectedStress = stress
                        }
                }
            }
            .padding(.bottom)
        }
    }
}
