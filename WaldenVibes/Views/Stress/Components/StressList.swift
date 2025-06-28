// StressList.swift
import SwiftUI

struct StressList: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedStress: Stress?
    @Binding var showingTips: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Current Stress Summary Card
                if let latestStress = dataManager.stressRecords.first {
                    CurrentStressCard(stress: latestStress)
                        .padding(.horizontal)
                        .padding(.top)
                }
                
                // Quick Tips Button
                Button(action: { showingTips = true }) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .font(.title3)
                        
                        VStack(alignment: .leading) {
                            Text("Stress Relief Tips")
                                .font(.headline)
                            Text("Tap for quick tips")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("AccentColor").opacity(0.1))
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                
                // History
                VStack(alignment: .leading, spacing: 12) {
                    Text("stress.history")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(dataManager.stressRecords) { stress in
                        StressCard(stress: stress)
                            .onTapGesture {
                                selectedStress = stress
                            }
                    }
                }
            }
            .padding(.bottom)
        }
    }
}
