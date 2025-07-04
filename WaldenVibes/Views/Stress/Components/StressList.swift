// WaldenVibes/Views/Stress/Components/StressList.swift
import SwiftUI

struct StressList: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var selectedStress: Stress?
    @Binding var showingTips: Bool
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Current Stress Summary Card
                if let latestStress = dataManager.stressRecords.first {
                    CurrentStressCard(stress: latestStress)
                        .padding(.horizontal)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                        .padding(.top)
                }
                
                // Quick Tips Button
                Button(action: { showingTips = true }) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .font(.title3)
                        
                        VStack(alignment: .leading) {
                            Text("Stress Relief Tips", comment: "Title for stress relief tips button")
                                .font(.headline)
                            Text("Tap for quick tips", comment: "Subtitle for stress relief tips button")
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
                .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity)
                
                // History
                VStack(alignment: .leading, spacing: 12) {
                    Text("Stress History", comment: "Section header for stress history")
                        .font(.headline)
                        .padding(.horizontal)
                        .frame(maxWidth: horizontalSizeClass == .regular ? 800 : .infinity, alignment: .leading)
                    
                    if horizontalSizeClass == .regular {
                        // iPad: Grid layout
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(dataManager.stressRecords) { stress in
                                StressCard(stress: stress)
                                    .onTapGesture {
                                        selectedStress = stress
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: 1000)
                    } else {
                        // iPhone: List layout
                        ForEach(dataManager.stressRecords) { stress in
                            StressCard(stress: stress)
                                .onTapGesture {
                                    selectedStress = stress
                                }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
    }
}
